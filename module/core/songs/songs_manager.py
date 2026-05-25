import logging
from pathlib import Path
from module.core.utils.app_data import AppData

logger: logging.Logger = logging.getLogger(__name__)

class SongManager:
    
    AUDIO_EXTENSIONS = {".mp3", ".wav", ".flac", ".ogg", ".m4a", ".aac", ".wma", ".opus"}

    songs: list = []

    @classmethod
    def query_all_songs(cls) -> list:
        cls.songs.clear()
        try:
            data_folder: Path = AppData.create_app_data_folder()
            songs: list[Path] = [
                song.absolute() for song in data_folder.iterdir()
                if song.is_file() and song.suffix.lower() in cls.AUDIO_EXTENSIONS
            ]
            cls.songs = songs
            return songs
        except Exception as e:
            logging.error(e)
            return []
