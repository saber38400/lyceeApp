package com.lycee.lycee_app.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
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

            File destination =
                    new File(uploadDir + fileName);

            file.transferTo(destination);

            post.setFileName(fileName);
            post.setFileType(file.getContentType());
        }

        postRepo.save(post);

        return "redirect:/dummy";
    }

    @GetMapping("/deletePost/{id}")
    public String deletePost(@PathVariable Integer id) {

        Post post = postRepo.findById(id).orElse(null);

        if(post != null) {

            if(post.getFileName() != null) {

                try {

                    String uploadDir =
                            System.getProperty("user.dir")
                            + "/uploads/";

                    Path filePath =
                            Paths.get(uploadDir + post.getFileName());

                    Files.deleteIfExists(filePath);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            postRepo.delete(post);
        }

        return "redirect:/dummy";
    }

    @PostMapping("/editPost")
    public String editPost(
            @RequestParam("id") Integer id,
            @RequestParam("content") String content) {

        Post post = postRepo.findById(id).orElse(null);

        if(post != null) {

            post.setContent(content);

            postRepo.save(post);
        }

        return "redirect:/dummy";
    }

    @GetMapping("/download/{fileName}")
    public ResponseEntity<byte[]> downloadFile(
            @PathVariable String fileName) throws IOException {

        String uploadDir =
                System.getProperty("user.dir")
                + "/uploads/";

        Path path = Paths.get(uploadDir + fileName);

        byte[] data = Files.readAllBytes(path);

        return ResponseEntity.ok()
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + fileName + "\"")
                .body(data);
    }

    @GetMapping("/deleteFile/{id}")
    public String deleteFile(@PathVariable Integer id) {

        Post post = postRepo.findById(id).orElse(null);

        if(post != null && post.getFileName() != null) {

            File file = new File("C:/uploads/" + post.getFileName());

            if(file.exists()) {
                file.delete();
            }

            post.setFileName(null);
            post.setFileType(null);

            postRepo.save(post);
        }

        return "redirect:/dummy";
    }
}
