package com.lycee.lycee_app.controller;

import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lycee.lycee_app.model.Message;
import com.lycee.lycee_app.model.User;

import com.lycee.lycee_app.repository.MessageRepository;
import com.lycee.lycee_app.repository.UserRepository;
import org.springframework.messaging.simp.SimpMessagingTemplate;

@Controller
public class MessageController {

    @Autowired
    private MessageRepository messageRepo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

@GetMapping("/messages")
    public String messages(
            HttpSession session,
            Model model)
    {

        String currentUser =
                (String) session.getAttribute("username");

        if(currentUser == null)
        {
            return "redirect:/login";
        }

        List<User> users =
                userRepo.findAll();

        model.addAttribute("users",users);

        model.addAttribute(
                "currentUser",
                currentUser);

        long unreadCount =
                messageRepo.countByReceiverAndReadMessageFalse(currentUser);

        model.addAttribute(
                "unreadCount",
                unreadCount);

        return "messages";
    }

@GetMapping("/messages/{receiver}")
    public String conversation(
            @PathVariable String receiver,
            HttpSession session,
            Model model)
    {

        String sender =
                (String) session.getAttribute("username");

        if(sender == null)
        {
            return "redirect:/login";
        }

        List<User> users =
                userRepo.findAll();

        List<Message> conversation =
                messageRepo.findConversation(
                        sender,
                        receiver);

        model.addAttribute("users",users);

        model.addAttribute(
                "messages",
                conversation);

        model.addAttribute(
                "receiver",
                receiver);

        model.addAttribute(
                "currentUser",
                sender);

        long unreadCount =
                messageRepo.countByReceiverAndReadMessageFalse(sender);

        model.addAttribute(
                "unreadCount",
                unreadCount);

        for(Message m : conversation)
        {

                if(m.getReceiver().equals(sender))
                {

                        m.setReadMessage(true);

                        messageRepo.save(m);

                }

        }

        return "messages";
    }

@PostMapping("/sendMessage")
    public String sendMessage(

            @RequestParam String receiver,

            @RequestParam String content,

            HttpSession session)

    {

        String sender =
                (String) session.getAttribute("username");

        if(sender == null)
        {
            return "redirect:/login";
        }

        if(content != null &&
                !content.trim().isEmpty())
        {

            Message message =
                    new Message();

            message.setSender(sender);

            message.setReceiver(receiver);

            message.setContent(content);

            messageRepo.save(message);

            messagingTemplate.convertAndSend(
                    "/topic/messages/" + receiver,
                    message);

        }

        return "redirect:/messages/"+receiver;

    }

}