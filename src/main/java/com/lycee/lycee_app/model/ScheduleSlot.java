package com.lycee.lycee_app.model;

import jakarta.persistence.*;

@Entity
@Table(name = "schedule_slots")
public class ScheduleSlot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String dayOfWeek;

    private String startTime;

    private String endTime;

    private String subject;

    private boolean lunchBreak = false;

    public Integer getId() {
        return id;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public boolean isLunchBreak() {
        return lunchBreak;
    }

    public void setLunchBreak(boolean lunchBreak) {
        this.lunchBreak = lunchBreak;
    }
}