import sys, platformdirs, logging

from importlib import metadata
from platformdirs import user_data_dir
from pathlib import Path

logger = logging.getLogger(__name__)

class AppData:

    @classmethod
    def check_platformdirs_lib(cls) -> bool:
        try:
            logger.debug(platformdirs.__version__)
            return True
        except metadata.PackageNotFoundError:
            logger.critical("There's no platformdirs library in this enviorment.")
            return False

    @classmethod
    def create_app_data_folder(cls) -> Path:
        if not cls.check_platformdirs_lib(): sys.exit(1)
        
        data_folder: Path = Path(user_data_dir("Sonority"))
        data_folder.mkdir(parents=True, exist_ok=True)
        logging.debug(data_folder.resolve())

        return data_folder.absolute()
    