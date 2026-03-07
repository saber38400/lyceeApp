package com.lycee.lycee_app.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.lycee.lycee_app.model.User;
import com.lycee.lycee_app.repository.UserRepository;


@Controller

public class UserController
{

    @Autowired
    UserRepository urepo;


    @RequestMapping("/")
    public String home() 
    {
        return "home";
    }


    @RequestMapping("/signup")
    public String getSignup()
    {
        return "signup";
    }

    @RequestMapping("/login")
    public String getLogin() 
    {
        return "login";
    }
    
    @PostMapping("/addUser")
    public ModelAndView addUser(@RequestParam("user_email") String user_email, User user)
     {
        ModelAndView mv=new ModelAndView("success");
        List<User> list= urepo.findByUserEmail(user_email);
        
        if(!list.isEmpty())
        {
        mv.addObject("message", "Oops! There is already a user registered with the email provided.");
        
        }
        else
        {
            urepo.save(user);
            mv.addObject("message", "User has been successfully registered.");
        }

        return mv;
    }
    @GetMapping("/dummy")
    public String dummy()
    {
        return "dummy";
    }

    @PostMapping("/login")
    public String login_user(@RequestParam("user_email") String email,
                         @RequestParam("user_pass") String pass,
                         HttpSession session,
                         ModelMap modelMap) 
{
        User user = urepo.findByUserEmailAndUserPass(email, pass);

        if(user!=null)
        {
            session.setAttribute("username", email);
            return "dummy";

        }

        modelMap.put("error", "Invalid Account");
        return "login";

        }

    @GetMapping(value = "/logout")
        public String logout_user(HttpSession session)
        {
            session.removeAttribute("username");
            session.invalidate();
            return "redirect:/login";
        }
            
    }
