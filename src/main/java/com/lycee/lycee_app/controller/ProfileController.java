package com.lycee.lycee_app.controller;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.lycee.lycee_app.model.User;
import com.lycee.lycee_app.repository.MessageRepository;
import com.lycee.lycee_app.repository.UserRepository;

@Controller
public class ProfileController {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private MessageRepository messageRepo;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/profil")
    public String profil(
            HttpSession session,
            Model model)
    {

        String username =
                (String) session.getAttribute("username");

        if(username == null)
        {
            return "redirect:/login";
        }

        List<User> list =
                userRepo.findByUserEmail(username);

        model.addAttribute(
                "user",
                list.isEmpty() ? null : list.get(0));

        long unreadCount =
                messageRepo.countByReceiverAndReadMessageFalse(username);

        model.addAttribute(
                "unreadCount",
                unreadCount);

        return "profil";

    }

    @PostMapping("/profil/updateInfo")
    public String updateInfo(
            @RequestParam String user_fname,
            @RequestParam String user_lname,
            @RequestParam(required = false) String user_birthdate,
            @RequestParam(required = false) String user_classe,
            HttpSession session)
    {

        String username =
                (String) session.getAttribute("username");

        if(username == null)
        {
            return "redirect:/login";
        }

        List<User> list =
                userRepo.findByUserEmail(username);

        if(!list.isEmpty())
        {

            User user = list.get(0);

            user.setUser_fname(user_fname);
            user.setUser_lname(user_lname);
            user.setUser_classe(user_classe);

            if(user_birthdate != null && !user_birthdate.isEmpty())
            {
                user.setUser_birthdate(LocalDate.parse(user_birthdate));
            }

            userRepo.save(user);

        }

        return "redirect:/profil";

    }

    @PostMapping("/profil/updatePhoto")
    public String updatePhoto(
            @RequestParam("photo") MultipartFile photo,
            HttpSession session) throws IOException
    {

        String username =
                (String) session.getAttribute("username");

        if(username == null)
        {
            return "redirect:/login";
        }

        List<User> list =
                userRepo.findByUserEmail(username);

        if(!list.isEmpty() && photo != null && !photo.isEmpty())
        {

            User user = list.get(0);

            String fileName =
                    System.currentTimeMillis()
                    + "_"
                    + photo.getOriginalFilename();

            String uploadDir =
                    System.getProperty("user.dir")
                    + "/uploads/";

            File uploadFolder = new File(uploadDir);

            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }

            photo.transferTo(new File(uploadDir + fileName));

            user.setUser_photo(fileName);

            userRepo.save(user);

        }

        return "redirect:/profil";

    }

    @PostMapping("/profil/updatePassword")
    public String updatePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            HttpSession session,
            Model model)
    {

        String username =
                (String) session.getAttribute("username");

        if(username == null)
        {
            return "redirect:/login";
        }

        List<User> list =
                userRepo.findByUserEmail(username);

        if(!list.isEmpty())
        {

            User user = list.get(0);

            if(passwordEncoder.matches(currentPassword, user.getUser_pass()))
            {
                user.setUser_pass(passwordEncoder.encode(newPassword));
                userRepo.save(user);
                model.addAttribute("passwordMessage", "Mot de passe modifié avec succès.");
            }
            else
            {
                model.addAttribute("passwordMessage", "Mot de passe actuel incorrect.");
            }

        }

        List<User> refreshedList =
                userRepo.findByUserEmail(username);

        model.addAttribute(
                "user",
                refreshedList.isEmpty() ? null : refreshedList.get(0));

        long unreadCount =
                messageRepo.countByReceiverAndReadMessageFalse(username);

        model.addAttribute(
                "unreadCount",
                unreadCount);

        return "profil";

    }

}