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

