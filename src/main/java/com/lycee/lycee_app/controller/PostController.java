package com.lycee.lycee_app.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.lycee.lycee_app.model.Post;
import com.lycee.lycee_app.repository.PostRepository;

@Controller
public class PostController {

    @Autowired
    private PostRepository postRepo;

    private final String uploadDir = "uploads/";

    @PostMapping("/createPost")
    public String createPost(
            @RequestParam("content") String content,
            @RequestParam("file") MultipartFile file,
            Model model) throws IOException {

        Post post = new Post();

        post.setAuthor("Saber");
        post.setContent(content);

        if (!file.isEmpty()) {

            String fileName = System.currentTimeMillis()
                    + "_" + file.getOriginalFilename();

            File uploadPath = new File(uploadDir);

            if (!uploadPath.exists()) {
                uploadPath.mkdirs();
            }

            file.transferTo(new File(uploadDir + fileName));

            post.setFileName(fileName);
            post.setFileType(file.getContentType());
        }

        postRepo.save(post);

        return "redirect:/dummy";
    }
}
