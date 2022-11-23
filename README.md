# 4AESE_Ethernet_Controller

Auteurs : Arthur Gautheron et Olivier Lagrost, 4AESE-TP3.

## 🌍 Introduction
Ce projet a été réalisé dans le cadre du cours **VHDL et circuits numériques** de Mme Daniela Dragomirescu. Il s'agit d'une version simplifiée de la couche MAC d'un contrôleur Ethernet. 

L'ensemble des fichiers ont été écrit en VHDL, puis synthétisés et implémentés avec Xilinx Vivado, et enfin testés en simulation et en réel sur une carte FPGA Basys3. Ce README détaille les fonctionnalités de chaque fichier.

Nous avons choisi une approche par "blocs", c'est-à-dire de créer pour chaque fonctionnalité du contrôleur un fichier .vhd, afin de pouvoir tester chaque fonctionnalité séparément et de donner une meilleure lisibilité à notre projet.

## 📁 source
Le dossier source contient tous les fichiers **.vhd** décrivant de manière comportementale le contrôleur Ethernet.

### 📄 emetteur.vhd
Ce fichier décrit comment le contrôleur éthernet construit une trame Ethernet à partir des informations qu'il reçoit, et comment les informations sont envoyées à la couche physique. 

### 📄 recepteur.vhd
Ce fichier décrit comment le contrôleur gère l'arrivée de données : déconstruction de la trame en arrivée, envoi de l'information à la couche supérieure si la trame est bien destinée à l'adresse MAC du contrôleur.

### 📄 collisions.vhd
Ce fichier décrit la gestion des collisions : lorsque le contrôleur essaie d'émettre et de recevoir des données, le gestionnaire de collisions avorte la transmission de données. La réception de données est donc **prioritaire** par rapport à l'émission.

### 📄 top.vhd
Ce fichier assemble les fichiers **emetteur.vhd**, **recepteur.vhd** et **collisions.vhd**. Il s'agit du fichier principal qui constitue LE contrôleur Ethernet dans sa globalité.

## 📁 test
# Le dossier test contient tous les fichiers **.vhd** permettant de tester en simulation les fichiers **.vhd**.

### 📄 emetteur_test.vhd


### 📄 recepteur_test.vhd


### 📄 collisions_test.vhd


### 📄 top_test.vhd
