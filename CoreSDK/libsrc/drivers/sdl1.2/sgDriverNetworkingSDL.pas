unit sgDriverNetworkingSDL;

interface
uses sgShared, sdl_net, sgNamedIndexCollection, sgTypes;

    //TCP Connection
    function CreateTCPHostProcedure              (const aPort : LongInt) : Boolean;
    function OpenTCPConnectionToHostProcedure    (const aDestIP : String; const aDestPort : LongInt) : Connection;
    function ServerAcceptTCPConnectionProcedure  () : LongInt;
  
    //TCP Message
    function BroadcastTCPMessageProcedure        (const aMsg : String) : Boolean;
    function SendTCPMessageToProcedure           (const aMsg : String; const aConnection : Connection) : Connection;
    function TCPMessageReceivedProcedure         () : Boolean;

    //UDP
    function CreateUDPSocketProcedure(const aPort : LongInt) : LongInt;
    function CreateUDPConnectionProcedure(aDestIP : String; aDestPort, aInPort : LongInt) : Connection; 
    function UDPMessageReceivedProcedure() : Boolean;
    function SendUDPMessageProcedure(const aMsg : String; const aConnection : Connection) : Boolean;

    //Close Sockets
    function CloseTCPHostSocketProcedure        (const aPort: LongInt) : Boolean;  
    function CloseConnectionProcedure           (var aConnection : Connection) : Boolean;
    function CloseUDPListenSocketProcedure      (const aPort : LongInt) : Boolean;
      
    procedure CloseAllTCPHostSocketProcedure    ();
    procedure CloseAllConnectionsProcedure      ();
    procedure CloseAllUDPListenSocketProcedure  ();

    function MyIPProcedure                      () : String;
    procedure FreeAllNetworkingResourcesProcedure ();
    //Initialisation
    procedure LoadSDLNetworkingDriver           (); 

implementation
uses SysUtils, sgUtils, sgNetworking, sgDriverNetworking, StrUtils;

type
  
  TCPSocketArray = Array of PTCPSocket;
  ConnectionArray = Array of Connection;
  UDPSocketArray = Array of PUDPSocket;

  TCPListenSocket = record
    socket : PTCPSocket;
    port   : LongInt;
  end;

var
  _ListenSockets          : Array of TCPListenSocket;
  _Connections            : ConnectionArray;
  _Socketset              : PSDLNet_SocketSet;

  _UDPListenSockets       : UDPSocketArray;
  _UDPSocketIDs           : NamedIndexCollection;
  _UDPConnectionIDs       : NamedIndexCollection;

  _UDPSendPacket          : PUDPPacket = nil;
  _UDPReceivePacket       : PUDPPacket = nil;
  _Buffer                 : Array [0..512] of Char;
  _BufferPtr              : ^Char;


//----------------------------------------------------------------------------
// Internal Functions
//----------------------------------------------------------------------------

  function CreateConnection() : Connection;
  begin
    New(result);
    result^.socket    := nil;
    result^.ip        := 0;
    result^.port      := 0;
    result^.firstmsg  := nil;
    result^.lastMsg   := nil;
    result^.msgCount  := 0;
    result^.isTCP     := True;
  end;

  function GetConnectionWithID(const aIP, aPort : LongInt; aIsTCP : Boolean) : Connection;
  var
    i : LongInt;
  begin
    result := nil;
    for i := Low(_Connections) to High(_Connections) do
    begin
      if (_Connections[i]^.ip = aIP) and (_Connections[i]^.port = aPort) and (_Connections[i]^.isTCP = aIsTCP) then
      begin
        result := _Connections[i];
      end;
    end;
  end;

  function ExtractData(aReceivedCount : LongInt) : String;
  var
    i      : LongInt;
    lSize  : Byte = 0;
    lSizeIdx : LongInt = 0;
    lComplete : Boolean = False;
  begin
    result := '';
    while not lComplete do
    begin      
      lSize := Byte(_Buffer[lSizeIdx]);
    
      for i := lSizeIdx + 1 to lSize do
      begin
        result += _Buffer[i];
      end;
      lSizeIdx := lSizeIdx + lSize + 1;
      if lSizeIdx = aReceivedCount then lComplete := True;
    end;
  end;
    
  function TCPIP(aNewSocket : PTCPSocket) : LongInt;
  var
    lRemoteIP : PIPAddress;
  begin
    lRemoteIP := SDLNet_TCP_GetPeerAddress(aNewSocket);
    result := SDLNet_Read32(@lRemoteIP^.host);
  end;

  function TCPPort(aNewSocket : PTCPSocket) : LongInt;
  var
    lRemoteIP : PIPAddress;
  begin
    lRemoteIP := SDLNet_TCP_GetPeerAddress(aNewSocket);
    result := SDLNet_Read16(@lRemoteIP^.port);
  end;

  function MyIPProcedure() : String;
  begin
    result := '127.0.0.1';
  end;

//----------------------------------------------------------------------------
// TCP Connection Handling
//----------------------------------------------------------------------------

  function OpenTCPConnection(aIP : PChar; aPort : LongInt) : PTCPSocket;
  var
    lIPAddress : TIPAddress;  
  begin
    result := nil;
    if (SDLNet_ResolveHost(lIPAddress, aIP, aPort) < 0) then
      exit;
    
    result := SDLNet_TCP_Open(lIPAddress); 
  end;

  function CreateTCPHostProcedure(const aPort : LongInt) : Boolean;
  var
    lTempSocket  : PTCPSocket = nil;
  begin
    lTempSocket := OpenTCPConnection(nil, aPort);
    if Assigned(lTempSocket) then
    begin
      SetLength(_ListenSockets, Length(_ListenSockets) + 1);
      _ListenSockets[High(_ListenSockets)].socket := lTempSocket;
      _ListenSockets[High(_ListenSockets)].port   := aPort;
    end;
    result := Assigned(lTempSocket);    
  end;

  function OpenTCPConnectionToHostProcedure(const aDestIP : String; const aDestPort : LongInt) : Connection;
  var
    lTempSocket : PTCPSocket = nil; 
  begin    
    result := nil;
    lTempSocket := OpenTCPConnection(PChar(aDestIP), aDestPort);
    if Assigned(lTempSocket) then
    begin
      result := CreateConnection();
      result^.IP            := TCPIP(lTempSocket);
      result^.port       := aDestPort;
      result^.socket        := lTempSocket;
      SetLength(_Connections, Length(_Connections) + 1);
      _Connections[High(_Connections)] := result;
      
      SDLNet_AddSocket(_SocketSet, PSDLNet_GenericSocket(lTempSocket));
    end;
  end;  

  function ServerAcceptTCPConnectionProcedure() : LongInt;
  var
    lTempSocket : PTCPSocket = nil;
    lNewConnection : Connection;
    i : LongInt;
  begin  
    result := 0;
    for i := Low(_ListenSockets) to High(_ListenSockets) do
    begin
      lTempSocket := SDLNet_TCP_Accept(_ListenSockets[i].socket);
      if Assigned(lTempSocket) then
      begin
        lNewConnection                := CreateConnection();
        lNewConnection^.IP            := TCPIP(lTempSocket);
        lNewConnection^.socket        := lTempSocket;
        lNewConnection^.port          := _ListenSockets[i].port;
        SetLength(_Connections, Length(_Connections) + 1);
        _Connections[High(_Connections)] := lNewConnection;
        SDLNet_AddSocket(_SocketSet, PSDLNet_GenericSocket(lTempSocket));
        EnqueueNewConnection(lNewConnection);
        result += 1;
      end;
    end;
  end;

//----------------------------------------------------------------------------
// TCP Message Handling
//----------------------------------------------------------------------------

  function TCPMessageReceivedProcedure() : Boolean;
   var
     i, lReceived : LongInt;
   begin
     result := False;
     if SDLNet_CheckSockets(_SocketSet, 0) < 1 then exit;
     for i := Low(_Connections) to High(_Connections) do
     begin
       if SDLNET_SocketReady(PSDLNet_GenericSocket(_Connections[i]^.socket)) then
       begin
         lReceived := SDLNet_TCP_Recv(_Connections[i]^.socket, _BufferPtr, 512);
         if (lReceived > 0) then
         begin
           EnqueueMessage(ExtractData(lReceived), _Connections[i]);
           result := True;
         end;
       end;
     end;
   end;

  function SendTCPMessageToProcedure(const aMsg : String; const aConnection : Connection) : Connection;
  var
    lLen, i : LongInt;
  begin
    result := nil;
    if (aConnection = nil) or (aConnection^.socket = nil) then begin RaiseWarning('SDL 1.2 SendTCPMessageToProcedure Illegal Connection Arguement'); exit; end;
    
    for i := 0 to Length(aMsg) + 1 do
    begin
      if i = 0 then
        _Buffer[i] := Char(Length(aMsg))
      else if  i < Length(aMsg) + 1 then
        _Buffer[i] := aMsg[i];
    end;
    
    lLen := Length(aMsg) + 1;
    
    if (SDLNet_TCP_Send(aConnection^.socket, _BufferPtr, lLen) < lLen) then
    begin
      result := aConnection;
      RaiseWarning('SDLNet_TCP_Send: ' + SDLNet_GetError());
    end;
  end;

  function BroadcastTCPMessageProcedure(const aMsg : String) : Boolean;
  var
    lLen, i : LongInt;
  begin
    result := True;   
    for i := 0 to Length(aMsg) + 1 do
    begin
      if i = 0 then
        _Buffer[i] := Char(Length(aMsg))
      else if  i < Length(aMsg) + 1 then
        _Buffer[i] := aMsg[i];
    end;
    
    lLen := Length(aMsg) + 1;
    for i := Low(_Connections) to High(_Connections) do
    begin
      if (SDLNet_TCP_Send(_Connections[i]^.socket, _BufferPtr, lLen) < lLen) then
      begin
        RaiseWarning('SDLNet_TCP_Send: ' + SDLNet_GetError());
      end;
    end;
  end;

//----------------------------------------------------------------------------
// UDP Connections
//----------------------------------------------------------------------------

  procedure CreatePackets();
  begin
    if _UDPSendPacket = nil then
      _UDPSendPacket := SDLNet_AllocPacket(512);
    if _UDPReceivePacket = nil then
      _UDPReceivePacket := SDLNet_AllocPacket(512);
  end;

  function CreateUDPSocketProcedure(const aPort : LongInt) : LongInt;
  var
    lTempSocket  : PUDPSocket = nil;  
    lPortID      : String;  
  begin    
    lPortID := IntToStr(aPort);
    result := -1;
    if HasName(_UDPSocketIDs, lPortID) then begin result := IndexOf(_UDPSocketIDs, lPortID); exit; end;
    lTempSocket := SDLNet_UDP_Open(aPort);
    if Assigned(lTempSocket) then
    begin
      SetLength(_UDPListenSockets, Length(_UDPListenSockets) + 1);
      _UDPListenSockets[High(_UDPListenSockets)] := lTempSocket;
      AddName(_UDPSocketIDs, lPortID);
      result := High(_UDPListenSockets);
    end;
    CreatePackets();
    if result = -1 then RaiseWarning('OpenUDPListenerPort: ' + SDLNET_GetError());
  end;
   
  function CreateUDPConnectionProcedure(aDestIP : String; aDestPort, aInPort : LongInt) : Connection; 
  var
    lIdx, lDecDistIP : LongInt;
    lDecIPStr : String;
  begin    
    result := nil;
    lDecDistIP := IPv4ToDec(aDestIP);
    lDecIPStr  := IntToStr(lDecDistIP);

    if HasName(_UDPConnectionIDs, lDecIPStr + ':' + IntToStr(aDestPort)) then exit;
    lIdx := CreateUDPSocketProcedure(aInPort);

    if (lIdx = -1) then begin RaiseWarning('SDL 1.2 - CreateUDPConnectionProcedure: Could not Bind Socket.'); exit; end;

    AddName(_UDPConnectionIDs, lDecIPStr + ':' + IntToStr(aDestPort));
    result := CreateConnection();
    result^.ip := lDecDistIP;
    result^.port := aDestPort;
    result^.isTCP := False;

    lIdx := CreateUDPSocketProcedure(aInPort);
    result^.socket := _UDPListenSockets[lIdx];
    SetLength(_Connections, Length(_Connections) + 1);
    _Connections[High(_Connections)] := result;
    CreatePackets();
    if not Assigned(result^.socket) then RaiseWarning('OpenUDPSendPort: ' + SDLNET_GetError());
  end;

//----------------------------------------------------------------------------
// UDP Message
//----------------------------------------------------------------------------

  function UDPMessageReceivedProcedure() : Boolean;
  var
    i, j          : LongInt;    
    lMsg          : String = '';
    lConnection   : Connection;
    lSrcIPString  : String;
    lNewConnection: Boolean = False;
    lSrcIP, lSrcPort : LongInt;
  begin
    result := False;
    for i := Low(_UDPListenSockets) to High(_UDPListenSockets) do
    begin
      if SDLNet_UDP_Recv(_UDPListenSockets[i], _UDPReceivePacket) > 0 then
      begin        
        lSrcIP      := SDLNet_Read32(@_UDPReceivePacket^.address.host);
        lSrcPort    := SDLNet_Read16(@_UDPReceivePacket^.address.port);
        lConnection := GetConnectionWithID(lSrcIP, lSrcPort, False);

        if not Assigned(lConnection) then
        begin
          lSrcIPString := HexStrToIPv4(DecToHex(lSrcIP));
          lConnection := CreateUDPConnectionProcedure(lSrcIPString, lSrcPort, StrToInt(NameAt(_UDPSocketIDs, i)));
          lNewConnection := True;
        end;
        
        if not Assigned(lConnection) then begin RaiseWarning('SDL 1.2 - UDPMessageReceivedProcedure: Could Not Create Connection.'); exit; end;

        for j := 0 to _UDPReceivePacket^.len - 1 do
          lMsg += Char((_UDPReceivePacket^.data)[j]);
        
        if lNewConnection then
          EnqueueNewConnection(lConnection);

        EnqueueMessage(lMsg, lConnection);
        result := True;
      end; 
    end;
  end;
  
  function SendUDPMessageProcedure(const aMsg : String; const aConnection : Connection) : Boolean;
  var
    lIPAddress : TIPaddress;
  begin
    result := False;
    if not Assigned(aConnection) then begin RaiseWarning('SDL 1.2 - SendUDPMessageProcedure: Unassigned Connection.'); exit; end;
    SDLNet_ResolveHost(lIPAddress, PChar(HexStrToIPv4(DecToHex(aConnection^.ip))), aConnection^.port);

    _UDPSendPacket^.address.host   := lIPAddress.host;
    _UDPSendPacket^.address.port   := lIPAddress.port;
    _UDPSendPacket^.len            := Length(aMsg);
    _UDPSendPacket^.data           := @(aMsg[1]);
    SDLNet_UDP_Send(aConnection^.socket, -1, _UDPSendPacket);
    result := True; 
  end;

//----------------------------------------------------------------------------
// Close Single
//----------------------------------------------------------------------------

  function CloseTCPHostSocketProcedure(const aPort : LongInt) : Boolean;
  var
    lTmpListenArray : Array of TCPListenSocket;
    offSet: LongInt = 0;
    i   : LongInt;
  begin
    result := False;
    if Length(_ListenSockets) = 0 then begin RaiseWarning('SDL 1.2 - CloseUDPListenSocketProcedure: Could Not Close TCP Socket.'); exit; end;
    SetLength(lTmpListenArray, Length(_ListenSockets));
    for i := Low(_ListenSockets) to High(_ListenSockets) do
    begin
      if (_ListenSockets[i].port = aPort) then
      begin
        offSet := 1;
        if Assigned(_ListenSockets[i].socket) then 
        begin
          SDLNet_TCP_Close(_ListenSockets[i].socket);
          result := True;
        end;
      end else
        lTmpListenArray[i - offset] := _ListenSockets[i];
    end;
    if (result) then
    begin
      _ListenSockets := lTmpListenArray; 
      SetLength(_ListenSockets, Length(_ListenSockets) - 1);
    end;
  end;

  function CloseConnectionProcedure(var aConnection : Connection) : Boolean;
  var
    lTmpConnectionArray : ConnectionArray;
    offSet: LongInt = 0;
    i : LongInt;
  begin
    result := False;
    if (Length(_Connections) = 0) or (not Assigned(aConnection)) then begin RaiseWarning('SDL 1.2 - CloseConnectionProcedure: Could Not Close Connection.'); exit; end;
    SetLength(lTmpConnectionArray, Length(_Connections) - 1);
    for i := Low(_Connections) to High(_Connections) do
    begin
      if (_Connections[i] = aConnection) then
      begin
        offSet := 1;
        if aConnection^.isTCP and Assigned(aConnection^.socket) then 
        begin
          SDLNet_TCP_DelSocket(_Socketset, aConnection^.socket);
          SDLNet_TCP_Close(aConnection^.socket);
          ClearMessageQueue(aConnection);
          FreeConnection(aConnection);
          result := True;
        end else if not aConnection^.isTCP then
          RemoveName(_UDPConnectionIDs, IntToStr(aConnection^.ip) + ':' + IntToStr(aConnection^.port));
      end else
        lTmpConnectionArray[i - offset] := _Connections[i];
    end;
    if (result) then
      _Connections := lTmpConnectionArray;
  end;
 
  function CloseUDPListenSocketProcedure(const aPort : LongInt) : Boolean;
  var
    lTmpSockets : Array of PUDPSocket;
    i, lOffset, lIdx  : LongInt;
  begin
    result := False;
    if Length(_UDPListenSockets) = 0 then begin RaiseWarning('SDL 1.2 - CloseUDPListenSocketProcedure: Could Not Close UDP Socket.'); exit; end;
    lIdx := IndexOf(_UDPSocketIDs, IntToStr(aPort));
    if lIdx = -1 then exit;
    RemoveName(_UDPSocketIDs, lIdx);
    lOffset := 0;
    SetLength(lTmpSockets, Length(_UDPListenSockets) - 1);
    for i := Low(_UDPListenSockets) to High(_UDPListenSockets) do
    begin
      if i = lIdx then 
      begin
        lOffset := 1;
        SDLNet_UDP_Close(_UDPListenSockets[i])
      end else
        lTmpSockets[i - lOffset] := _UDPListenSockets[i];
    end;
    _UDPListenSockets := lTmpSockets; 
    result := True;
  end;

//----------------------------------------------------------------------------
// Close All
//----------------------------------------------------------------------------

  procedure CloseAllTCPHostSocketProcedure();
  var
    i : LongInt;
  begin    
    for i := Low(_ListenSockets) to High(_ListenSockets) do
      SDLNet_TCP_Close(_ListenSockets[i].socket);
    SetLength(_ListenSockets, 0);
  end;

  procedure CloseAllConnectionsProcedure();
  var
    i : LongInt;
  begin
    for i := Low(_Connections) to High(_Connections) do
    begin
      ClearMessageQueue(_Connections[i]);
      if (_Connections[i]^.isTCP) then 
      begin
        SDLNet_DelSocket(_SocketSet, _Connections[i]^.socket);
        SDLNet_TCP_Close(_Connections[i]^.socket);
      end else
        RemoveAllNamesInCollection(_UDPConnectionIDs);
      FreeConnection(_Connections[i]);
    end;
    SetLength(_Connections, 0);
  end;

  procedure CloseAllUDPListenSocketProcedure();
  var
    i : LongInt;
  begin
    for i := Low(_UDPListenSockets) to High(_UDPListenSockets) do
      SDLNet_UDP_Close(_UDPListenSockets[i]);
    SetLength(_UDPListenSockets, 0);
  end;  

  procedure FreeAllNetworkingResourcesProcedure();
  begin
    CloseAllConnectionsProcedure();
    CloseAllTCPHostSocketProcedure();
    CloseAllUDPListenSocketProcedure();
      
    if Assigned(_UDPReceivePacket) then
    begin
      SDLNet_FreePacket(_UDPReceivePacket);
      _UDPReceivePacket := nil;
    end;
    if Assigned(_SocketSet) then
    begin
      SDLNet_FreeSocketSet(_SocketSet);
      _SocketSet := nil;
    end;
 //   _UDPSendPacket is not Allocated
 //   if Assigned(_UDPSendPacket) then
 //     SDLNet_FreePacket(_UDPSendPacket);   
    FreeNamedIndexCollection(_UDPSocketIDs);
    FreeNamedIndexCollection(_UDPConnectionIDs);
  end;

//----------------------------------------------------------------------------
// Init
//----------------------------------------------------------------------------
  
  procedure LoadSDLNetworkingDriver(); 
   begin
     NetworkingDriver.CreateTCPHost               := @CreateTCPHostProcedure;
     NetworkingDriver.OpenTCPConnectionToHost     := @OpenTCPConnectionToHostProcedure;
     NetworkingDriver.ServerAcceptTCPConnection   := @ServerAcceptTCPConnectionProcedure;
     NetworkingDriver.TCPMessageReceived          := @TCPMessageReceivedProcedure;
     NetworkingDriver.BroadcastTCPMessage         := @BroadcastTCPMessageProcedure;
     NetworkingDriver.SendTCPMessageTo            := @SendTCPMessageToProcedure;
 
     NetworkingDriver.CreateUDPSocket             := @CreateUDPSocketProcedure;
     NetworkingDriver.CreateUDPConnection         := @CreateUDPConnectionProcedure;
     NetworkingDriver.UDPMessageReceived          := @UDPMessageReceivedProcedure;
     NetworkingDriver.SendUDPMessage              := @SendUDPMessageProcedure;
 
     NetworkingDriver.CloseTCPHostSocket          := @CloseTCPHostSocketProcedure;
     NetworkingDriver.CloseConnection             := @CloseConnectionProcedure;
     NetworkingDriver.CloseUDPListenSocket        := @CloseUDPListenSocketProcedure;
 
     NetworkingDriver.MyIP                        := @MyIPProcedure;
 
     NetworkingDriver.CloseAllTCPHostSocket       := @CloseAllTCPHostSocketProcedure;     
     NetworkingDriver.CloseAllConnections         := @CloseAllConnectionsProcedure;   
     NetworkingDriver.CloseAllUDPListenSocket     := @CloseAllUDPListenSocketProcedure; 

     NetworkingDriver.FreeAllNetworkingResources  := @FreeAllNetworkingResourcesProcedure;
   end;
  
  initialization 
  begin
    if (SDLNet_Init() < 0) then
  		RaiseWarning('SDLNet_Init: ' + SDLNet_GetError())
  	else
  	  _BufferPtr := @_Buffer;
    _SocketSet := SDLNET_AllocSocketSet(16);
    InitNamedIndexCollection(_UDPSocketIDs);
    InitNamedIndexCollection(_UDPConnectionIDs);
  end;

  finalization
  begin
    FreeAllNetworkingResourcesProcedure();
    SDLNet_Quit();
  end;
end.