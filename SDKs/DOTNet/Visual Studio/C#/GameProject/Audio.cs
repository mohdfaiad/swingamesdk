using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace SwinGame
{
    class Audio
    {
        /// <summary>
        /// Sound Effect Structure
        /// </summary>
        public struct SoundEffect
        {
            internal IntPtr Pointer;
        }

        /// <summary>
        /// Music Structure
        /// </summary>
        public struct Music
        {
            internal IntPtr Pointer;
        }

        [DllImport("SGSDK.dll")]
        public static extern void OpenAudio();
        [DllImport("SGSDK.dll")]
        public static extern void CloseAudio();

        [DllImport("SGSDK.dll", EntryPoint="PlaySoundEffect")]
        private static extern void DLL_PlaySoundEffect(IntPtr effect);
        [DllImport("SGSDK.dll", EntryPoint = "PlaySoundEffectLoop")]
        private static extern void DLL_PlaySoundEffectLoop(IntPtr effect, int loops );
        /// <summary>
        /// Play the indicated sound effect a number of times
        /// </summary>
        /// <param name="effect">The Sound Effect to play</param>
        /// <param name="loops">The number of times to play it</param>
        public static void PlaySoundEffect(SoundEffect effect, int loops)
        {
            if (loops == 1)
            {
                DLL_PlaySoundEffect(effect.Pointer);
            }
            else
            {
                DLL_PlaySoundEffectLoop(effect.Pointer, loops);
            }
            
        }

        [DllImport("SGSDK.dll", EntryPoint="LoadSoundEffect")]
        private static extern IntPtr DLL_LoadSoundEffect(String path);
        /// <summary>
        /// Loads a SoundEffect
        /// </summary>
        /// <param name="path">Path to the Sound Effect file</param>
        /// <returns>A SoundEffect</returns>
        public static SoundEffect LoadSoundEffect(String path)
        {
            SoundEffect effect;
            effect.Pointer = DLL_LoadSoundEffect(path);
            return effect;
        }

        [DllImport("SGSDK.dll", EntryPoint="FreeSoundEffect")]
        private static extern void DLL_FreeSoundEffect(ref IntPtr effect);
        /// <summary>
        /// Frees a Sound Effect From Memory
        /// </summary>
        /// <param name="effect">The effect to be freed from memory</param>
        public static void FreeSoundEffect(ref SoundEffect effect)
        {
            DLL_FreeSoundEffect(effect.Pointer);
        }

        [DllImport("SGSDK.dll", EntryPoint = "LoadMusic")]
        private static extern IntPtr DLL_LoadMusic(String path);
        /// <summary>
        /// Load music to play from the file system. Music can be in the form of a
        ///	wav, ogg, or mp3 file.
        /// </summary>
        /// <param name="Path">Path to Music file</param>
        /// <returns>Music</returns>
        public static Music LoadMusic(String Path)
        {
            Music music;
            music.Pointer = DLL_LoadMusic(Path);
            return music;
        }

        [DllImport("SGSDK.dll", EntryPoint="FreeMusic")]
        private static extern void DLL_FreeMusic(ref IntPtr effect);
        /// <summary>
        /// Free a music value. All loaded music values need to be freed.
        /// </summary>
        /// <param name="music">Music to be freed</param>
        public static void FreeMusic(ref Music music)
        {
            DLL_FreeMusic(effect.Pointer);
        }

    }
}
