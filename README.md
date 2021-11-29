# 2DHouseGen-Godot
Generator of 2D houses for Godot v3.3.3 (might work with Godot 3.4)

https://waterstop.itch.io/2d-house-generator - web version to generate houses without forking the repository
### Features
Generate:
1) a suburb house

![s1](https://user-images.githubusercontent.com/62846387/143858607-0468bf29-50c3-4ccb-b134-14d5521dedd8.png)

2) a high house

![h1](https://user-images.githubusercontent.com/62846387/143859114-518da341-81a8-4ffb-bdaa-04622ab1f55a.png)

3) a city

![c1](https://user-images.githubusercontent.com/62846387/143859506-1a5d0d8e-93f5-45c0-b832-42f672b370dd.png)


### About house generation
* **Each room in a house is accesible via stairs by 2x1 player (he won't hit his head on the ceiling)** Very rarely it is not true (only in the extreme cases, see below)
* Each room has its own type. Furniture spawns according to that type.

### Suburb house generation algorithm
*Not describing high house alorithm because it is very simple: stack floors on ech other and make sre that rooms have different widths*
*This description should give some cues about what is happening. Comments are hints too. All random operations have customizable bounds, like room width or number of rooms/floors*

1) Create 1st floor(*choose random width for rooms and choose random amount of rooms*), add doors between all rooms and on the sides of the floor
2) Create *i*-th floor which is not wider than previous
3) Connect *i*-th floor to the previous by stairs. If impossible, connect with a ladder
4) Add doors between rooms on *i*-th floor
5) Repeat 2-3 for all floors from 2 to n
6) Merge rooms together into 2x2 big room between 1st and 2nd floor or into 2x1 room in *i*-th and *i-1*-th floor. 
7) Add windows for each side room except 1st floor with respect to big rooms merged on a previous step (these rooms might have larger windows)

### Code
Code has comments, it is possible to figure out what it does.
* Each structure class has stateDump function for debugging
* Create functions have params (e.g. number of houses in a city)
* There is a Player class, he can open doors
* Platforms are on the different Tilemap because of the ladders
* Room specific furnitures can be tweaked in Furniture.gd dictionaries
* All tilemap resources can be changed and will work perfectly with custom ones (if you provide the right names for the tiles or create your own dictionaries)

### Examples
More suburb houses:

![s2](https://user-images.githubusercontent.com/62846387/143858864-04c07c02-c2dd-4dca-8e97-19d921d68460.png)

![s3](https://user-images.githubusercontent.com/62846387/143858879-1c7b24d1-d0a8-4245-8487-71f30d28ee32.png)

High house with a staircase in the middle:

![h2](https://user-images.githubusercontent.com/62846387/143859612-f4e01987-eae2-4ee3-b873-0ff2ae206f96.png)

Suburbian town:

![c2](https://user-images.githubusercontent.com/62846387/143859696-7e350341-8b12-41c3-9168-1921e33ab226.png)

The "Pyramid" (suburb house with 50 floors and 50 rooms on 1st floor)

![p1](https://user-images.githubusercontent.com/62846387/143860034-5bcd0dea-5a0e-426c-8c9a-8d32a5e79774.png)

Close-up (case when floors are not accessible because of room merging):

![p2](https://user-images.githubusercontent.com/62846387/143860062-1f9a6396-13bb-43fb-8389-703c53a9f6bc.png)

