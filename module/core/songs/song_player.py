import asyncio
import logging
from pathlib import Path
from flet_audio import Audio, ReleaseMode

Logger: logging.Logger = logging.getLogger(__name__)

class SongPlayer(Audio):

    current_song: SongPlayer | None = None

    def __init__(self, song_path: Path) -> None:
        super().__init__(src=str(song_path))
        self.autoplay = False
        self.volume = 0.1
        self.balance = 0.0
        self.release_mode = ReleaseMode.STOP
        self.on_loaded = lambda _: Logger.info(f"Loaded {song_path.stem}")

        SongPlayer.current_song = self

    @classmethod
    async def release_song(cls) -> None:
        if cls.current_song is not None:
            await cls.current_song.release()
            cls.current_song = None

    # Play song function
    @classmethod
    async def play_song(cls, e=None) -> None:
        if e is None: return

        # Release current song
        await SongPlayer.release_song()
        
        try:
            async def _execute_play(e):
                song = SongPlayer(e.control.data["path"])
                await asyncio.sleep(0.25)
                await song.play()

            await asyncio.wait_for(_execute_play(e), timeout=2.0)
        except asyncio.TimeoutError:
            Logger.error("Can't play this song, took too long to load.")
        except Exception as e:
            Logger.error(f"Can't play this song due to {e}")
