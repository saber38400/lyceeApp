package com.lycee.lycee_app.repository;

import com.lycee.lycee_app.model.Note;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NoteRepository extends JpaRepository<Note, Integer> {

    List<Note> findByStudentEmail(String studentEmail);

}