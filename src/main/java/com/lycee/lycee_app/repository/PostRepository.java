package com.lycee.lycee_app.repository;

import com.lycee.lycee_app.model.Post;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostRepository extends JpaRepository<Post, Integer> {
}