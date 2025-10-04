#! /usr/bin/env python3

import socket
import time


class Bot:
    def __init__(self, server, channel, botnick, botpass, port=6667):
        """
        Initialise votre bot. prend en paramètre le serveur, le port (par default 6667), le canal, le nom de votre
        bot, et son mot de passe
        """
        self.irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        
        print("Connecting to: " + server)
        self.irc.connect((server, port))

        self.irc.send(bytes("USER " + botnick + " " + botnick +" " + botnick + " :python\n", "UTF-8"))
        self.irc.send(bytes("NICK " + botnick + "\n", "UTF-8"))
        self.irc.send(bytes("NICKSERV IDENTIFY " + botnick + " " + botpass + "\n", "UTF-8"))
        time.sleep(5)

        self.irc.send(bytes("JOIN " + channel + "\n", "UTF-8"))
 
    def send(self, channel, msg):
        """
        envoie un message
        """
        self.irc.send(bytes("PRIVMSG " + channel + " " + msg + "\n", "UTF-8"))
        
    def send_privmsg(self, user, msg):
        """
        envoie un message privé à un utilisateur spécifique
        """
        self.irc.send(bytes("PRIVMSG " + user + " :" + msg + "\n", "UTF-8"))
        
 
    def get_response(self, buff=2040):
        """
        retourne la réponse
        """
        time.sleep(1)
        rep = self.irc.recv(buff).decode("UTF-8")
 
        if rep.find('PING') != -1:                      
            self.irc.send(bytes('PONG ' + rep + '\r\n', "UTF-8")) 
 
        return rep
