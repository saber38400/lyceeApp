package com.lycee.lycee_app.controller;

import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.lycee.lycee_app.model.Note;
import com.lycee.lycee_app.repository.MessageRepository;
import com.lycee.lycee_app.repository.NoteRepository;

@Controller
public class NoteController {

    @Autowired
    private NoteRepository noteRepo;

    @Autowired
    private MessageRepository messageRepo;

    @GetMapping("/notes")
    public String notes(
            HttpSession session,
            Model model)
    {

        String username =
                (String) session.getAttribute("username");

        if(username == null)
        {
            return "redirect:/login";
        }

        List<Note> notes =
                noteRepo.findByStudentEmail(username);

        double average = 0;

        if(!notes.isEmpty())
        {

            double total = 0;

            for(Note n : notes)
            {

                total = total
                        + (n.getNoteValue() / n.getMaxValue()) * 20;

            }

            average = total / notes.size();

        }

        String formattedAverage =
                String.format("%.2f", average);

        model.addAttribute("notes", notes);

        model.addAttribute(
                "average",
                formattedAverage);

        long unreadCount =
                messageRepo.countByReceiverAndReadMessageFalse(username);

        model.addAttribute(
                "unreadCount",
                unreadCount);

        return "notes";
    }

}