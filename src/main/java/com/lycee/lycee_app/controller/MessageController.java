package com.lycee.lycee_app.controller;

import com.lycee.lycee_app.dto.ChatMessage;
import com.lycee.lycee_app.model.Message;
import com.lycee.lycee_app.repository.MessageRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MessageController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private MessageRepository messageRepo;

    @GetMapping("/messages")
    public String messages() {
        return "messages";
    }

    @MessageMapping("/send")
    public void sendMessage(ChatMessage chatMessage) {

        Message message = new Message();

        message.setSender(chatMessage.getSender());
        message.setReceiver(chatMessage.getReceiver());
        message.setContent(chatMessage.getContent());

        messageRepo.save(message);

        messagingTemplate.convertAndSend(
                "/topic/" + chatMessage.getReceiver(),
                chatMessage);
    }
}