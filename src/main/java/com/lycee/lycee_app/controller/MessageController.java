package com.lycee.lycee_app.controller;

import java.util.List;
import java.io.File;
import java.io.IOException;
import org.springframework.web.multipart.MultipartFile;

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

        Message lastReadMessage = null;

        for(Message m : conversation)
        {

                if(m.getReceiver().equals(sender))
                {

                        m.setReadMessage(true);

                        messageRepo.save(m);

                        lastReadMessage = m;

                }

        }

        if(lastReadMessage != null)
        {

                messagingTemplate.convertAndSend(
                        "/topic/read/" + lastReadMessage.getSender(),
                        lastReadMessage);

        }

        return "messages";
    }

@PostMapping("/sendMessage")
    public String sendMessage(

            @RequestParam String receiver,

            @RequestParam(required = false) String content,

            @RequestParam(value = "file", required = false) MultipartFile file,

            HttpSession session) throws IOException

    {

        String sender =
                (String) session.getAttribute("username");

        if(sender == null)
        {
            return "redirect:/login";
        }

        boolean hasContent =
                content != null && !content.trim().isEmpty();

        boolean hasFile =
                file != null && !file.isEmpty();

        if(hasContent || hasFile)
        {

            Message message =
                    new Message();

            message.setSender(sender);

            message.setReceiver(receiver);

            message.setContent(hasContent ? content : "");

            if(hasFile)
            {

                String fileName =
                        System.currentTimeMillis()
                        + "_"
                        + file.getOriginalFilename();

                String uploadDir =
                        System.getProperty("user.dir")
                        + "/uploads/";

                File uploadFolder = new File(uploadDir);

                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs();
                }

                file.transferTo(new File(uploadDir + fileName));

                message.setFileName(fileName);

            }

            messageRepo.save(message);

            messagingTemplate.convertAndSend(
                    "/topic/messages/" + receiver,
                    message);

        }

        return "redirect:/messages/"+receiver;

    }

}