package com.lycee.lycee_app.controller;

import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lycee.lycee_app.model.Note;
import com.lycee.lycee_app.model.ScheduleSlot;
import com.lycee.lycee_app.model.User;
import com.lycee.lycee_app.repository.NoteRepository;
import com.lycee.lycee_app.repository.ScheduleRepository;
import com.lycee.lycee_app.repository.UserRepository;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private NoteRepository noteRepo;

    @Autowired
    private ScheduleRepository scheduleRepo;

    private boolean isAdmin(HttpSession session) {

        String username = (String) session.getAttribute("username");

        if(username == null)
        {
            return false;
        }

        List<User> list = userRepo.findByUserEmail(username);

        return !list.isEmpty() && list.get(0).isAdmin();

    }

    @GetMapping("")
    public String dashboard(HttpSession session, Model model) {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        model.addAttribute("students", userRepo.findAll());

        return "admin";

    }

    @GetMapping("/notes/{email}")
    public String manageNotes(
            @PathVariable String email,
            HttpSession session,
            Model model)
    {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        model.addAttribute("notes", noteRepo.findByStudentEmail(email));
        model.addAttribute("studentEmail", email);

        return "admin-notes";

    }

    @PostMapping("/notes/save")
    public String saveNote(
            @RequestParam(required = false) Integer id,
            @RequestParam String studentEmail,
            @RequestParam String subject,
            @RequestParam Double noteValue,
            @RequestParam Double maxValue,
            @RequestParam String dateNote,
            HttpSession session)
    {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        Note note =
                (id != null)
                ? noteRepo.findById(id).orElse(new Note())
                : new Note();

        note.setStudentEmail(studentEmail);
        note.setSubject(subject);
        note.setNoteValue(noteValue);
        note.setMaxValue(maxValue);
        note.setDateNote(LocalDate.parse(dateNote));

        noteRepo.save(note);

        return "redirect:/admin/notes/" + studentEmail;

    }

    @GetMapping("/notes/{email}/delete/{id}")
    public String deleteNote(
            @PathVariable String email,
            @PathVariable Integer id,
            HttpSession session)
    {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        noteRepo.deleteById(id);

        return "redirect:/admin/notes/" + email;

    }

    @GetMapping("/planning")
    public String managePlanning(HttpSession session, Model model) {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        model.addAttribute("slots", scheduleRepo.findAll());

        return "admin-planning";

    }

    @PostMapping("/planning/save")
    public String savePlanning(
            @RequestParam(required = false) Integer id,
            @RequestParam String dayOfWeek,
            @RequestParam String startTime,
            @RequestParam String endTime,
            @RequestParam String subject,
            @RequestParam(required = false) Boolean lunchBreak,
            HttpSession session)
    {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        ScheduleSlot slot =
                (id != null)
                ? scheduleRepo.findById(id).orElse(new ScheduleSlot())
                : new ScheduleSlot();

        slot.setDayOfWeek(dayOfWeek);
        slot.setStartTime(startTime);
        slot.setEndTime(endTime);
        slot.setSubject(subject);
        slot.setLunchBreak(lunchBreak != null && lunchBreak);

        scheduleRepo.save(slot);

        return "redirect:/admin/planning";

    }

    @GetMapping("/planning/delete/{id}")
    public String deletePlanning(
            @PathVariable Integer id,
            HttpSession session)
    {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        scheduleRepo.deleteById(id);

        return "redirect:/admin/planning";

    }

    @GetMapping("/promote/{email}")
    public String promote(
            @PathVariable String email,
            HttpSession session)
    {

        if(!isAdmin(session))
        {
            return "redirect:/dummy";
        }

        List<User> list = userRepo.findByUserEmail(email);

        if(!list.isEmpty())
        {
            User user = list.get(0);
            user.setAdmin(true);
            userRepo.save(user);
        }

        return "redirect:/admin";

    }

}