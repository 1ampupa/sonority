import logging
import flet as ft

from flet import Column

Logger: logging.Logger = logging.getLogger(__name__)

class GuiSongPlayer(Column):
    
    def __init__(self) -> None:
        super().__init__()
        
        # Set the default to false on the startup
        self.visible = False

        # Column Elements
        self.title_text = ft.Text(
            value="Song title",
            size=16,
            weight=ft.FontWeight.BOLD
        )
        self.artist_text = ft.Text(
            value="Song artist",
            size=12
        )

        self.controls.append(
            ft.Column(
                controls=[
                    self.title_text,
                    self.artist_text
                ],
                spacing=3,
                align=ft.Alignment.CENTER_LEFT
            )
        )

    async def show(self, current_song):
        if not current_song:
            Logger.warning("There's no song playing")
            return
        
        # Update Information
        self.title_text.value = current_song.song_title
        self.artist_text.value = current_song.song_artist

        self.visible = True

        self.update()
        
    async def hide(self):
        self.visible = False
        self.update()

