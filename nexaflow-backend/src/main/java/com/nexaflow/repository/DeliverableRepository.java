package com.nexaflow.repository;

import com.nexaflow.entity.Deliverable;
import com.nexaflow.entity.Project;
import com.nexaflow.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DeliverableRepository extends JpaRepository<Deliverable, String> {
    
    List<Deliverable> findByProject(Project project);
    
    List<Deliverable> findByProjectOrderByCreatedAtDesc(Project project);
    
    List<Deliverable> findByClient(User client);
    
    List<Deliverable> findByClientOrderByCreatedAtDesc(User client);
}
