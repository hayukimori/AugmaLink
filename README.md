
<div align="center">

<img src="readme_demos/project_bnr_rdm.png" width=100%>

</div>

# Augma Link

Augma Link is a project that attempts to recreate the interface and functionality of the movie *Sword Art Online: Ordinal Scale*, with icons and functionality created with GDScript. using [Redot Engine](https://www.redotengine.org) as the main engine.

![screenshot](readme_demos/preview.png)

# Applications

Augma Link (Ordina Scale UI) has some applications made in GDScript, but some require attention to run.

> [!WARNING]
> Applications are not finalized yet

## Chat Application
The chat is not fully implemented with the program. But it is functional with a mosquitto server.

I recommend that you edit the addresses before running.

To connect to the server, edit the "Nickname" and click "Connect" to start `mosquitto` connection.



![gif](readme_demos/demo_1.gif)



> [!IMPORTANT]
> This application is still under testing, and is not 100% functional. I would be very grateful if you could report any errors or suggestions for changes to the code.



## Music Application
It's a simple application without many features. Made only for MP3 testing purposes.


![gif2](readme_demos/demo_2.gif)


<hr>

# Android support
Augma Link was propused to run on android devices.
There's a script attached to Camera3D, it collects _magnometer_ and _gyroscope_ data and send it to the camera rotation.

It was made thanks to [this tutotrial](https://github.com/ramatakinc/mobile-sensors-tutorial) from [ramatakinc](https://github.com/ramatakinc).


# Icons and Textures
<div align="center">

![texture1](assets/textures/UI_items/SAO_OS_TOPBAR.png)

Some icons for this project were found on Google Fonts, and the icons related to SAO OS I recreated myself using inkskape 

<br>

![icon1](assets/textures/icons/chat_app_icon_sao_os.png)
![icon2](assets/textures/icons/map_icon_sao_os.png)
![icon3](assets/textures/icons/music_player_icon_sao_os.png)
![icon4](assets/textures/icons/weather_icon_sao_os.png)

these are some examples of what inkscape can do.
<br>



![texture2](assets/textures/UI_items/SAO_OS_BOTTOMLAYER.png)

</div>


# Addons

I used some addons that I believe helped me a lot in what I wanted to do.
They are:

> [TextureRectRounded](https://godotengine.org/asset-library/asset/2591) (kuruk-mm)

> [godot-mqtt](https://github.com/goatchurchprime/godot-mqtt) (goatchurchprime)


# Warnings
> I do not own any rights to the work Sword Art Online: Ordinal Scale, or any of the artwork involved.

> This project **does not** aim to make a profit or gain any commercial advantage from the Sword Art Online brand.

> All applications within this project are made exclusively for learning purposes.
