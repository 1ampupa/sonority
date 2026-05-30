import asyncio
import logging
import flet as ft
import flet_audio as fta

from pathlib import Path
from tinytag import TinyTag
from flet_audio import Audio, ReleaseMode

Logger: logging.Logger = logging.getLogger(__name__)

class SongPlayer:
    _active_audio: Audio | None = None
    
    current_song: 'SongPlayer | None' = None
    song_path: Path | None = None
    song_title: str = ""
    song_artist: str = ""
    song_duration: float = 0
    song_state = fta.AudioState.STOPPED

    @classmethod
    async def play_song(cls, page: ft.Page, song_player_column, e=None) -> None:
        if e is None or e.control.data is None: 
            return

        try:
            async def _execute_play(e):
                path: Path = e.control.data["path"]
                
                if cls._active_audio is not None:
                    try: await cls._active_audio.release()
                    except: pass
                
                metadata = await asyncio.to_thread(TinyTag.get, path.absolute())
                
                cls.song_path = path
                cls.song_title = metadata.title if metadata.title is not None else path.stem
                cls.song_artist = metadata.artist if metadata.artist is not None else "Local file"
                cls.song_duration = metadata.duration if metadata.duration is not None else 0
                
                inst = cls()
                inst.song_title = cls.song_title
                inst.song_artist = cls.song_artist
                inst.song_duration = cls.song_duration
                cls.current_song = inst

                cls._active_audio = Audio(
                    src=str(path.absolute()),
                    volume=0.25,  
                    release_mode=ReleaseMode.LOOP,
                    on_position_change=lambda e: page.run_task(song_player_column.update_infomation, e)
                )
                
                await asyncio.sleep(0.1)
                await cls._active_audio.play()
                cls.song_state = fta.AudioState.PLAYING

                await song_player_column.update_pause_resume_button(cls)
                await song_player_column.show(cls.current_song)

            await asyncio.wait_for(_execute_play(e), timeout=2.0)
        except asyncio.TimeoutError:
            Logger.error("Can't play this song, took too long to load.")
        except Exception as err:
            Logger.error(f"Can't play this song due to {err}")

    @classmethod
    async def toggle_pause_resume(cls, song_player_column):
        if cls._active_audio is not None:
            if cls.song_state is fta.AudioState.PLAYING:
                cls.song_state = fta.AudioState.STOPPED
                await cls._active_audio.pause()
            elif cls.song_state is fta.AudioState.STOPPED:
                cls.song_state = fta.AudioState.PLAYING
                await cls._active_audio.resume()
            await song_player_column.update_pause_resume_button(cls)

    @classmethod
    async def seek(cls):
        if cls._active_audio is not None:
            await cls._active_audio.seek(5)
