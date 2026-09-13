package com.lycee.lycee_app.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.lycee.lycee_app.model.ScheduleSlot;
import com.lycee.lycee_app.repository.MessageRepository;
import com.lycee.lycee_app.repository.ScheduleRepository;

@Controller
public class ScheduleController {

    @Autowired
    private ScheduleRepository scheduleRepo;

    @Autowired
    private MessageRepository messageRepo;

    @GetMapping("/emploi-du-temps")
    public String emploiDuTemps(
            HttpSession session,
            Model model)
    {

        String username =
                (String) session.getAttribute("username");

        if(username == null)
        {
            return "redirect:/login";
        }

        List<String> days =
                List.of("Lundi","Mardi","Mercredi","Jeudi","Vendredi");

        Map<String, List<ScheduleSlot>> planning =
                new LinkedHashMap<>();

        for(String day : days)
        {

            planning.put(
                    day,
                    scheduleRepo.findByDayOfWeekOrderByStartTime(day));

        }

        model.addAttribute("planning", planning);

        long unreadCount =
                messageRepo.countByReceiverAndReadMessageFalse(username);

        model.addAttribute(
                "unreadCount",
                unreadCount);

        return "emploi-du-temps";
    }

}