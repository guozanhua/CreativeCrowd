package edu.inlab.service;

import edu.inlab.models.Task;

import java.util.List;

/**
 * Created by inlab-dell on 2016/5/10.
 */
public interface TaskService {
    Task findById(int id);
    List<Task> findByOwnerId(int ownerId);
    List<Task> getOpenTasks(int startId, int count);
    List<Task> getOpenTasks(int count);
    void saveTask(Task task);
    void updateTask(Task task);
    void deleteTaskById(int id);
}