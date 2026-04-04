package com.nexaflow.repository;

import com.nexaflow.entity.Milestone;
import com.nexaflow.entity.Project;
import com.nexaflow.entity.User;
import com.nexaflow.enums.MilestoneStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MilestoneRepository extends JpaRepository<Milestone, String> {
    
    List<Milestone> findByProject(Project project);
    
    List<Milestone> findByProjectOrderByDueDateAsc(Project project);
    
    List<Milestone> findByClient(User client);
    
    List<Milestone> findByClientOrderByDueDateAsc(User client);
    
    List<Milestone> findByStatus(MilestoneStatus status);
    
    long countByProjectAndStatus(Project project, MilestoneStatus status);
}
