<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../session-check.jspf" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="../Header.jsp" %>
        <title>Project Calendar</title>
        <link rel="stylesheet" href="../CanlendarProject.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="container">
            
            <%@include file="../Sidebar.jsp"%>
           
            <main class="main-content">
                
                <div class="project-header-bar">
                    <div class="project-header-name">
                        <i class="fas fa-calendar-alt"></i>
                        Project Calendar
                    </div>
                    <div class="project-header-actions">
                        <button class="project-action-btn project-filter-btn" title="Filter">
                            <i class="fas fa-filter"></i>
                        </button>
                        <button class="project-action-btn project-pin-btn" title="Pin">
                            <i class="fas fa-thumbtack"></i>
                        </button>
                        <button class="project-action-btn project-visibility-btn">
                            <i class="fas fa-eye"></i>
                            Change visibility
                        </button>
                        <button class="project-action-btn project-share-btn">
                            <i class="fas fa-share-alt"></i>
                            Share
                        </button>
                        <button class="project-action-btn project-more-btn" title="More options">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>
                    </div>
                </div>
                
                <div class="calendar-box">
                    <div class="calendar-header">
                        <select id="month-year" class="month-year-select">
                            <!-- Options will be populated by JavaScript -->
                        </select>
                        
                        <button id="prev-month" class="nav-btn prev-btn" title="Previous">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        
                        <span id="current-week" class="current-period">This day</span>
                        
                        <button id="next-month" class="nav-btn next-btn" title="Next">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                        
                        <div class="view-mode">
                            <select id="view-mode-select" class="view-mode-select">
                                <option value="month">
                                    <i class="fas fa-calendar"></i> Month
                                </option>
                                <option value="week">
                                    <i class="fas fa-calendar-week"></i> Week
                                </option>
                                <option value="day">
                                    <i class="fas fa-calendar-day"></i> Day
                                </option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="calendar-content">
                        <div class="sidebar-calendar">
                            <div class="sidebar-calendar-header">
                                <button id="prev-month-sidebar" class="sidebar-nav-btn" title="Previous Month">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <span id="sidebar-month-year" class="sidebar-month-title">May, 2025</span>
                                <button id="next-month-sidebar" class="sidebar-nav-btn" title="Next Month">
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                            </div>
                            <table class="sidebar-calendar-table">
                                <thead>
                                    <tr>
                                        <th>S</th>
                                        <th>M</th>
                                        <th>T</th>
                                        <th>W</th>
                                        <th>T</th>
                                        <th>F</th>
                                        <th>S</th>
                                    </tr>
                                </thead>
                                <tbody id="sidebar-calendar-body">
                                    <!-- Calendar dates will be populated by JavaScript -->
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="calendar-wrapper">
                            <table class="calendar">
                                <thead>
                                    <tr>
                                        <th>Sunday</th>
                                        <th>Monday</th>
                                        <th>Tuesday</th>
                                        <th>Wednesday</th>
                                        <th>Thursday</th>
                                        <th>Friday</th>
                                        <th>Saturday</th>
                                    </tr>
                                </thead>
                                <tbody id="calendar-body">
                                    <!-- Calendar content will be populated by JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <div class="calendar-actions">
                        <button id="add-event-btn" class="add-btn">
                            <i class="fas fa-plus"></i>
                            Add Event
                        </button>
                        <button id="today-btn" class="today-btn">
                            <i class="fas fa-calendar-day"></i>
                            Today
                        </button>
                    </div>
                </div>
            </main>
        </div>
        
        <script src="../CanlendarProject.js"></script>
    </body>
</html>