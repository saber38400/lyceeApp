package com.lycee.lycee_app.repository;

import com.lycee.lycee_app.model.ScheduleSlot;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ScheduleRepository extends JpaRepository<ScheduleSlot, Integer> {

    List<ScheduleSlot> findByDayOfWeekOrderByStartTime(String dayOfWeek);

}