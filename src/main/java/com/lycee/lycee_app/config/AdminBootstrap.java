package com.lycee.lycee_app.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.lycee.lycee_app.model.User;
import com.lycee.lycee_app.repository.UserRepository;

@Component
public class AdminBootstrap implements CommandLineRunner {

    @Autowired
    private UserRepository userRepo;

    @Override
    public void run(String... args) {

        List<User> list =
                userRepo.findByUserEmail("saber.be@gmail.com");

        if(!list.isEmpty())
        {

            User user = list.get(0);

            if(!user.isAdmin())
            {
                user.setAdmin(true);
                userRepo.save(user);
            }

        }

    }

}