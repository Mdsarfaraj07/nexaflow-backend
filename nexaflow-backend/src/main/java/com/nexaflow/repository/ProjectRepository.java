package com.nexaflow.repository;

import com.nexaflow.entity.Project;
import com.nexaflow.entity.User;
import com.nexaflow.enums.ProjectStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProjectRepository extends JpaRepository<Project, String> {
    
    List<Project> findByClient(User client);
    
    List<Project> findByClientOrderByCreatedAtDesc(User client);
    
    List<Project> findByStatus(ProjectStatus status);
    
    List<Project> findByClientAndStatus(User client, ProjectStatus status);
    
    List<Project> findAllByOrderByCreatedAtDesc();
}
