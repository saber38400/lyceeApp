package com.lycee.lycee_app.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.lycee.lycee_app.dto.ChatMessage;
import com.lycee.lycee_app.model.Message;

@Controller
public class ChatController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/send")
    @SendTo("/topic/messages")
    public Message send(Message message) {

        return message;

    }

    @MessageMapping("/typing")
    public void typing(ChatMessage typingMessage) {

        messagingTemplate.convertAndSend(
                "/topic/typing/" + typingMessage.getReceiver(),
                typingMessage);

    }

}