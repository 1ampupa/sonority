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
        
        # Song Information

        # Song Title
        self.title_text = ft.Text(
            value="Song title",
            size=18,
            max_lines=1,
            overflow=ft.TextOverflow.ELLIPSIS,
            weight=ft.FontWeight.BOLD
        )

        # Song Artist
        self.artist_text = ft.Text(
            value="Song artist",
            style=ft.TextStyle(color=ft.Colors.SECONDARY),
            size=14,
            max_lines=1,
            overflow=ft.TextOverflow.ELLIPSIS
        )

        # Playback controller

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
            thumb_color="#FFFFFF",
            active_color=ft.Colors.PRIMARY,
            inactive_color=ft.Colors.SECONDARY,
            on_change_start=self.use_manual_slider,
            on_change_end=lambda _: self._page.run_task(self.update_time)
        )

        # Allow the slider to be automatically changed when the song position changes
        self.allow_automatic_slider = True

        # Icon for Pause Button
        self.pause_icon = ft.Icon(
            icon=ft.Icons.PAUSE,
            size=30,
            color=ft.Colors.ON_PRIMARY
        )

        # Icon for Resume Button
        self.resume_icon = ft.Icon(
            icon=ft.Icons.PLAY_ARROW,
            size=30,
            color=ft.Colors.SURFACE_CONTAINER
        )

        # Tooltip for Pause/Resume Button
        self.pause_resume_tooltip = ft.Tooltip(
            message="Pause",
            wait_duration=500,
            prefer_below=False
        )

        # Pause/Resume Button
        self.pause_resume_button = ft.IconButton(
            icon=self.pause_icon,
            icon_color=ft.Colors.SURFACE_CONTAINER_LOW,
            bgcolor=ft.Colors.PRIMARY,
            icon_size=40,
            padding=0,
            align=ft.Alignment.CENTER,
            tooltip=self.pause_resume_tooltip,
            on_click=lambda _: self._page.run_task(SongPlayer.toggle_pause_resume, self)
        )

        # Next Track Button
        self.next_track_button = ft.IconButton(
            icon=ft.Icon(ft.Icons.SKIP_NEXT),
            icon_size=25,
            padding=0,
            align=ft.Alignment.CENTER,
            tooltip=ft.Tooltip(message="Next",wait_duration=500,prefer_below=False)
        )

        # Previous Track Button
        self.previous_track_button = ft.IconButton(
            icon=ft.Icon(ft.Icons.SKIP_PREVIOUS),
            icon_size=25,
            padding=0,
            align=ft.Alignment.CENTER,
            tooltip=ft.Tooltip(message="Previous",wait_duration=500,prefer_below=False)
        )

        # Seek skip 5 second Button
        self.seek_skip_button = ft.IconButton(
            icon=ft.Icon(ft.Icons.KEYBOARD_ARROW_RIGHT),
            icon_size=30,
            padding=0,
            align=ft.Alignment.CENTER,
            tooltip=ft.Tooltip(message="Skip",wait_duration=500,prefer_below=False),
            on_click=lambda _: self._page.run_task(self.seek, True)
        )

        # Seek rewind 5 second Button
        self.seek_rewind_button = ft.IconButton(
            icon=ft.Icon(ft.Icons.KEYBOARD_ARROW_LEFT),
            icon_size=30,
            padding=0,
            align=ft.Alignment.CENTER,
            tooltip=ft.Tooltip(message="Rewind",wait_duration=500,prefer_below=False),
            on_click=lambda _: self._page.run_task(self.seek, False)
        )

        # Icon for Shuffle Button
        self.shuffle_icon = ft.Icon(
            icon=ft.Icons.SHUFFLE,
            size=18,
            color=ft.Colors.ON_PRIMARY
        )
        
        # Tooltip for Shuffle Button
        self.shuffle_tooltip = ft.Tooltip(
            message="Enable Shuffle",
            wait_duration=500,
            prefer_below=False
        )

        # Shuffle mode button
        self.shuffle_button = ft.IconButton(
            icon=self.shuffle_icon,
            icon_color=ft.Colors.SURFACE_CONTAINER_LOW,
            bgcolor=ft.Colors.ON_SECONDARY_CONTAINER,
            icon_size=18,
            padding=0,
            align=ft.Alignment.CENTER,
            tooltip=self.shuffle_tooltip,
            on_click=lambda _: self._page.run_task(SongPlayer.toggle_shuffle, self)
        ) 

        # Icon for Loop mode Button
        self.loop_icon = ft.Icon(
            icon=ft.Icons.REPEAT,
            size=18,
            color=ft.Colors.ON_PRIMARY
        )

        # Tooltip for Loop mode Button
        self.loop_mode_tooltip = ft.Tooltip(
            message="Enable Loop",
            wait_duration=500,
            prefer_below=False
        )

        # Loop mode button
        self.loop_mode_button = ft.IconButton(
            icon=self.loop_icon,
            icon_color=ft.Colors.SURFACE_CONTAINER_LOW,
            bgcolor=ft.Colors.ON_SECONDARY_CONTAINER,
            icon_size=18,
            padding=0,
            align=ft.Alignment.CENTER,
            tooltip=self.loop_mode_tooltip,
            on_click=lambda _: self._page.run_task(SongPlayer.toggle_loop_mode, self)
        )

        # Renderer
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
                                        self.shuffle_button,
                                        self.previous_track_button,
                                        self.seek_rewind_button,
                                        self.pause_resume_button,
                                        self.seek_skip_button,
                                        self.next_track_button,
                                        self.loop_mode_button
                                    ],
                                    height=50,
                                    spacing=10,
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

    # Helper Functions

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
    
    async def update_playback_buttons(self, audio: SongPlayer):
        # Pause / Resume Button
        if audio.song_state is fta.AudioState.PLAYING:
            self.pause_resume_button.icon = self.pause_icon
            self.pause_resume_button.bgcolor = ft.Colors.PRIMARY
            self.pause_resume_tooltip.message = "Pause"
        elif audio.song_state is fta.AudioState.STOPPED:
            self.pause_resume_button.icon = self.resume_icon
            self.pause_resume_button.bgcolor = ft.Colors.ON_SURFACE
            self.pause_resume_tooltip.message = "Resume"

        if audio._active_audio is not None:
            # Shuffle Button
            if audio.shuffle:
                self.shuffle_button.bgcolor = ft.Colors.PRIMARY
                self.shuffle_tooltip.message = "Disable Shuffle"
            elif not audio.shuffle:
                self.shuffle_button.bgcolor = ft.Colors.SURFACE_CONTAINER_LOW
                self.shuffle_tooltip.message = "Enable Shuffle"

            # Loop mode Button
            if audio.repeat_mode is fta.ReleaseMode.LOOP:
                self.loop_mode_button.bgcolor = ft.Colors.PRIMARY
                self.loop_mode_tooltip.message = "Disable Loop"
            elif audio.repeat_mode is fta.ReleaseMode.STOP:
                self.loop_mode_button.bgcolor = ft.Colors.SURFACE_CONTAINER_LOW
                self.loop_mode_tooltip.message = "Enable Loop"

        self.update()

    def use_manual_slider(self):
        self.allow_automatic_slider = False

    async def update_time(self):
        if SongPlayer._active_audio is not None and self.slider.value is not None:
            await SongPlayer.change_time(self.slider.value)
        self.allow_automatic_slider = True

    async def seek(self, skip: bool = True):
        if SongPlayer._active_audio is not None:
            await SongPlayer.seek(skip)
