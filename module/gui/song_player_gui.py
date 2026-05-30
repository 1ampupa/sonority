import math
import logging
import flet as ft
import flet_audio as fta

from flet import Column
from module.core.songs.song_player import SongPlayer

Logger: logging.Logger = logging.getLogger(__name__)

class GuiSongPlayer(Column):
    
    def __init__(self, page: ft.Page) -> None:
        super().__init__()
        self._page = page
        
        # Set the default to False on the startup
        self.visible = False

        # Column Elements

        # Song Title
        self.title_text = ft.Text(
            value="Song title",
            size=16,
            max_lines=1,
            overflow=ft.TextOverflow.ELLIPSIS,
            weight=ft.FontWeight.BOLD
        )

        # Song Artist
        self.artist_text = ft.Text(
            value="Song artist",
            style=ft.TextStyle(color=ft.Colors.SECONDARY),
            size=12,
            max_lines=1,
            overflow=ft.TextOverflow.ELLIPSIS
        )

        # Song current duration
        self.current_duration_text = ft.Text(
            value="00:00",
            weight=ft.FontWeight.BOLD,
            size=12,
            width=40,
            align=ft.Alignment.CENTER_LEFT
        )

        # Song duration
        self.duration_text = ft.Text(
            value="00:00",
            weight=ft.FontWeight.BOLD,
            size=12,
            width=40,
            align=ft.Alignment.CENTER_RIGHT
        )

        # Song Slider
        self.slider = ft.Slider(
            value=0,
            min=0,
            max=1,
            width=300,
            padding=0,
            on_change_start=self.try_update_time,
            on_change_end=lambda _: self._page.run_task(self.update_time)
        )

        # Allow the slider to be automatically changed when the song position changes
        self.allow_automatic_slider = True

        # Pause/Resume Button
        self.pause_resume_button = ft.IconButton(
            icon=ft.Icon(ft.Icons.PAUSE_CIRCLE_FILLED),
            icon_size=40,
            padding=0,
            align=ft.Alignment.CENTER,
            on_click=lambda _: self._page.run_task(SongPlayer.toggle_pause_resume, self)
        )

        # Next Track Button
        self.next_track_button = ft.IconButton(
            icon=ft.Icon(ft.Icons.SKIP_NEXT),
            icon_size=30,
            padding=0,
            align=ft.Alignment.CENTER
        )

        # Previous Track Button
        self.previous_track_button = ft.IconButton(
            icon=ft.Icon(ft.Icons.SKIP_PREVIOUS),
            icon_size=30,
            padding=0,
            align=ft.Alignment.CENTER
        )

        self.controls.append(
            ft.Container(
                bgcolor=ft.Colors.SURFACE_CONTAINER_LOW,
                border_radius=10,
                padding=10,
                alignment=ft.Alignment.CENTER,
                content=ft.Row(
                    alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                    controls=[
                        ft.Column(
                            width=250,
                            spacing=5,
                            tight=True,
                            alignment=ft.MainAxisAlignment.START,
                            controls=[
                                self.title_text,
                                self.artist_text
                            ]
                        ),
                        ft.Column(
                            expand=True,
                            spacing=5,
                            tight=True,
                            alignment=ft.MainAxisAlignment.CENTER,
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            controls=[
                                ft.Row(
                                    controls=[
                                        self.previous_track_button,
                                        self.pause_resume_button,
                                        self.next_track_button
                                    ],
                                    height=40,
                                    spacing=15,
                                    alignment=ft.MainAxisAlignment.CENTER,
                                    vertical_alignment=ft.CrossAxisAlignment.CENTER       
                                ),
                                ft.Row(
                                    controls=[
                                        self.current_duration_text,
                                        self.slider,
                                        self.duration_text
                                    ],
                                    height=20,
                                    spacing=10,
                                    alignment=ft.MainAxisAlignment.CENTER,
                                    vertical_alignment=ft.CrossAxisAlignment.CENTER
                                )
                            ]
                        ),
                        ft.Container(width=250)
                    ]
                )      
            )
        )

    async def show(self, current_song):
        if not current_song:
            Logger.warning("There's no song playing")
            return
        
        # Update Information
        self.title_text.value = current_song.song_title
        self.artist_text.value = current_song.song_artist
        self.slider.value = 0
        self.slider.max = math.floor(current_song.song_duration)

        # Formatting duration string
        minute = math.floor(current_song.song_duration / 60)
        second = math.floor(current_song.song_duration % 60)
        if minute < 10: minute = f"0{minute}"
        if second < 10: second = f"0{second}"
        self.duration_text.value = f"{minute}:{second}"

        self.visible = True

        self.update()
        
    async def hide(self):
        self.visible = False
        self.update()
    
    async def update_infomation(self, e: fta.AudioPositionChangeEvent):
        try:
            song_duration = e.position / 1000
            if self.allow_automatic_slider:
                self.slider.value = song_duration

            # Formatting duration string
            minute = math.floor(song_duration / 60)
            second = math.floor(song_duration % 60)
            if minute < 10: minute = f"0{minute}"
            if second < 10: second = f"0{second}"

            self.current_duration_text.value = f"{minute}:{second}"
        except Exception:
            pass
        finally:
            self.update()
    
    async def update_pause_resume_button(self, audio: SongPlayer):
        try:
            if audio.song_state is fta.AudioState.STOPPED:
                self.pause_resume_button.icon = ft.Icon(ft.Icons.PLAY_CIRCLE_FILL)
            elif audio.song_state is fta.AudioState.PLAYING:
                self.pause_resume_button.icon = ft.Icon(ft.Icons.PAUSE_CIRCLE_FILLED)
        except Exception:
            pass
        finally:
            self.update()

    def try_update_time(self):
        self.allow_automatic_slider = False
        self.update()

    async def update_time(self):
        if SongPlayer._active_audio is not None and self.slider.value is not None:
            await SongPlayer.change_time(self.slider.value)
        self.allow_automatic_slider = True
        self.update()
