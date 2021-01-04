# Computer Vision Project: Dobble finder

## Authors:
* **Conesa Fernández, Daniel Fco**
* **De Luca, Francesco**
* **Díaz Pérez, Rodrigo**
* **Moreno Escudero, Germán**
* **Rivera Cardenas, Gabriel**

## Description

_Computer vision algorithm for the recognition of the matching figure between two cards in the Dobble game._

The algorithm mainly uses the SIFT algorithm developed by [David Lowe](https://www.cs.ubc.ca/~lowe/keypoints/) and the RANSAC method as a filter. The functions developed by [Peter Kovesi](https://www.peterkovesi.com/matlabfns/) are used to filter outliners by RANSAC.

## User interface

A user interface (Programa_final.m) was developed in which the comparison image can be obtained in two ways:
* Connecting remotely via WIFI to a mobile camera with the IP_Webcam application.
* Loading an image from the database of letters generated during the development of the algorithm.

Once the image is loaded you should use the save button if an image has been captured by the camera or use the load image button if an image has been selected from the database.
Finally, with the image loaded, you can proceed to compare the two cards.

The images can be found at the following link: https://drive.google.com/drive/folders/13kqq4UGEHLgV42QO_86jxBNC3ix2UVX0?usp=sharing

## Universidad Politécnica de Madrid
**MUAR, January 2021**
