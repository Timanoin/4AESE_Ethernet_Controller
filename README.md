# 4AESE_Ethernet_Controller

Auteurs : Arthur Gautheron et Olivier Lagrost, 4AESE-TP3.

## 🌍 Introduction
Ce projet a été réalisé dans le cadre du cours **VHDL et circuits numériques** de Mme Daniela Dragomirescu. Il s'agit d'une version simplifiée de la couche MAC d'un contrôleur Ethernet. 

L'ensemble des fichiers ont été écrit en VHDL, puis synthétisés et implémentés avec Xilinx Vivado, et enfin testés en simulation et en réel sur une carte FPGA Basys3. Ce README détaille les fonctionnalités de chaque fichier.

Nous avons choisi une approche par "blocs", c'est-à-dire de créer pour chaque fonctionnalité du contrôleur un fichier .vhd, afin de pouvoir tester chaque fonctionnalité séparément et de donner une meilleure lisibilité à notre projet.

## 🎞️ Trame Ethernet

Une trame Ethernet est constituée de différents éléments.

- SFD (Start Frame Delimitor) : un octet 0b01010100 qui indique le début d'une trame.

- Adresse du destinataire : l'adresse du contrôleur Ethernet qui va recevoir les données, codée sur 6 octets.

- Adresse de la source : l'adresse du contrôleur Ethernet qui envoie les données, codée sur 6 octets.

- Données

- EFD  (End Frame Delimitor) : un octet 0b10101011 qui indique la fin d'une trame.

## 📁 source
Le dossier source contient tous les fichiers **.vhd** décrivant de manière comportementale le contrôleur Ethernet.

### 📄 emetteur.vhd
Ce fichier décrit comment le contrôleur éthernet construit une trame Ethernet à partir des informations qu'il reçoit, et comment les informations sont envoyées à la couche physique. 

Si RENABP = 1, le contrôleur reste en attente de données sur RDATAI. Lorsque un SFD arrive sur RDATAI, alors le contrôleur se met en mode récepteur.

Il va interpréter les 6 prochains octets arrivants comme l'adresse du destinataire : 
- si jamais il ne s'agit pas de son adresse (NOADDRI), alors le contrôleur stoppe la réception et se remet en attente.
- sinon la réception continue.

Les 6 prochains octets correspondent à l'adresse de la source : ils sont transmis à la couche supérieure, ainsi que les octets suivants car il s'agit de données. Jusqu'à ce que l'un d'entre eux soit un EFD : la réception est alors finie.

### 📄 recepteur.vhd
Ce fichier décrit comment le contrôleur gère l'arrivée de données : déconstruction de la trame en arrivée, envoi de l'information à la couche supérieure si la trame est bien destinée à l'adresse MAC du contrôleur.

Le contrôleur reste en attente d'une impulsion sur TAVAILP : cela signifie qu'une trame va devoir être envoyée. Il passe alors en mode transmission.

Il va d'abord construire un EFD et l'envoyer sur TDATAO, vers la couche physique. Puis il va envoyer l'adresse destinataire, qu'il transmet depuis TDATAI. Il va ensuite construire sa propre adresse en 6 octets et les envoyers 1 par 1.
 
Puis le contrôleur va simplement transmettre les données de TDATAI vers TDATAO jusqu'à ce qu'il recoive une impulsion sur TLASTP. 
A ce moment, la donnée envoyée est la dernière. Le prochain octet à envoyer est donc l'EFD, pour indiquer la fin de trame.

### 📄 collisions.vhd
Ce fichier décrit la gestion des collisions : lorsque le contrôleur essaie d'émettre et de recevoir des données, le gestionnaire de collisions avorte la transmission de données. La réception de données est donc **prioritaire** par rapport à l'émission.

### 📄 top.vhd
Ce fichier assemble les fichiers **emetteur.vhd**, **recepteur.vhd** et **collisions.vhd**. Il s'agit du fichier principal qui constitue LE contrôleur Ethernet dans sa globalité.

## 📁 test
Le dossier test contient tous les fichiers **.vhd** permettant de tester en simulation les fichiers **.vhd**.

### 📄 emetteur_test.vhd
Fichier de test unitaire de l'emetteur en simulation.

### 📄 recepteur_test.vhd
Fichier de test unitaire du récepteur en simulation.

### 📄 collisions_test.vhd
Fichier de test unitaire du gestionnaire de collisions en simulation.

### 📄 top_test.vhd
Fichier de test pour la simulation du composant complet.

### Signaux utilisés 
En réception :
RBYTEP : Une impulsion envoyée quand un nouvel octet de donnée est disponible dans RDATAO
RCLEANP : Une impulsion envoyée quand la trame reçue ne nous est pas destinée ou qu'elle est trop courte
RCVNGP : Un niveau qui est mis à 1 en sortie à la réception du SFD et remis à zéro à la fin de la réception de la trame
RDATAO : Ce sont les 8 bits de données que nous envoyons aux niveaux supérieurs
RDATAI : Ce sont les 8 bits de données que nous recevons en entrée
RDONEP : Une impulsion envoyée quand tous les octets de données sont reçus et valides
RENABP : Un niveau que nous recevons nous disant que nous sommes en réception et que nous pouvons recevoir des trames
RSMATIP : Un niveau qui est mis à 1 en sortie quand l'adresse du récepteur de la trame correspond à la notre
RSTARTP : Une impulsion qui est envoyée à la réception du SFD 

En émission : 
TABORTP : Une impulsion qui, quand elle est reçue, arrête toute émission et envoie 32 bits de 0 et de 1 alternés
TAVAILP : Un niveau que nous recevons à 1 quand des données sont disponibles pour être envoyées puis remis à 0 à la fin de la transmission ou en cas d'erreur
TDATAI : Ce sont les 8 bits de données que nous recevons des niveaux supérieurs
TDATAO : Ce sont les 8 bits de données que nous envoyons en sortie
TDONEP : Une impulsion signalant la fin à la fin d'une transmission même s'il y a une erreur
TFINISHP : Un niveau que nous recevons à 1 quand il faut stopper la transmision et ne pas en commencer de nouvelle tant qu'il n'est pas à 0
TLASTP : Une impulsion recue qui indique que la donnée dans TDATAI est la dernière à envoyer
TREADDP : Une impulsion envoyée quand les données dasn TDATAI ont été lues
TRNSMTP : Un niveau qui est mis à 1 en sortie pour indiquer que nous sommes en transmission 
TSTARTP : Une impulsion envoyée pour indiquer le début de la transmission 

Autres :
TSOCOLP : Un niveau qui est mis à 1 en sortie en cas de collision
RESETN : Un niveau qui doit être à 0 pendant 200ns au moins avant de transmettre ou recevoir des trames afin d'initialiser et de remettre tous les signaux à leur valeur d'origine
CLK : Signal d'horloge de notre système, un tic d'horloge vaut 10 ns 


