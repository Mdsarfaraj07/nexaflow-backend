package com.nexaflow.repository;

import com.nexaflow.entity.Project;
import com.nexaflow.entity.TimeEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TimeEntryRepository extends JpaRepository<TimeEntry, String> {
    
    List<TimeEntry> findByProject(Project project);
    
    List<TimeEntry> findByProjectOrderByEntryDateDesc(Project project);
    
    @Query("SELECT SUM(t.hours) FROM TimeEntry t WHERE t.project = ?1")
    Double sumHoursByProject(Project project);
    
    @Query("SELECT SUM(t.hours) FROM TimeEntry t WHERE t.project = ?1 AND t.isBillable = true")
    Double sumBillableHoursByProject(Project project);
}
