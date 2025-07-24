<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to BeeTask - Interactive Tutorial</title>
    
    <!-- Modern Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Favicon -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🐝</text></svg>">
    
    <!-- Styles -->
    <link rel="stylesheet" href="tutorial.css">
    
    <!-- Meta Tags for SEO -->
    <meta name="description" content="Learn BeeTask with our interactive tutorial - Master project management in 5 easy steps">
    <meta name="keywords" content="BeeTask, tutorial, project management, onboarding">
    <meta name="author" content="BeeTask Team">
    
    <!-- Open Graph Meta Tags -->
    <meta property="og:title" content="BeeTask Tutorial - Learn Project Management">
    <meta property="og:description" content="Interactive tutorial to master BeeTask project management platform">
    <meta property="og:type" content="website">
    
    <!-- Preload Critical Resources -->
    <link rel="preload" href="tutorial.css" as="style">
    <link rel="preload" href="tutorial.js" as="script">
</head>
<body>
    <!-- Tutorial Application -->
    <div id="tutorialApp" class="tutorial-app" role="application" aria-label="BeeTask Interactive Tutorial">
        
        <!-- Accessibility Skip Link -->
        <a href="#tutorial-content" class="skip-link">Skip to tutorial content</a>
        
        <!-- Loading Screen -->
        <div id="loadingScreen" class="loading-screen">
            <div class="loading-animation">
                <div class="bee-loader">🐝</div>
                <div class="loading-text">Preparing your tutorial...</div>
            </div>
        </div>
        
        <!-- Skip Button -->
        <button id="skipBtn" class="skip-button" aria-label="Skip Tutorial" title="Skip Tutorial (ESC)">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
            <span>Skip Tutorial</span>
        </button>

        <!-- Progress Section -->
        <div class="progress-section" role="progressbar" aria-valuenow="1" aria-valuemin="1" aria-valuemax="5">
            <div class="progress-bar">
                <div id="progressFill" class="progress-fill"></div>
            </div>
            <div class="step-counter" aria-live="polite">
                <span id="currentStep">1</span> of <span id="totalSteps">5</span>
            </div>
        </div>

        <!-- Tutorial Content -->
        <main id="tutorial-content" class="tutorial-main">
            
            <!-- Step 1: Welcome -->
            <section id="step-1" class="tutorial-step active" aria-labelledby="step-1-title">
                <div class="step-container">
                    <div class="step-visual">
                        <div class="welcome-illustration">
                            <div class="floating-cards">
                                <div class="card card-1" role="img" aria-label="Task management card">
                                    <div class="card-header"></div>
                                    <div class="card-content">
                                        <div class="task-item"></div>
                                        <div class="task-item"></div>
                                        <div class="task-item"></div>
                                    </div>
                                </div>
                                <div class="card card-2" role="img" aria-label="Analytics chart card">
                                    <div class="card-header"></div>
                                    <div class="card-content">
                                        <div class="chart-bar" style="height: 60%"></div>
                                        <div class="chart-bar" style="height: 80%"></div>
                                        <div class="chart-bar" style="height: 40%"></div>
                                    </div>
                                </div>
                                <div class="card card-3" role="img" aria-label="Team collaboration card">
                                    <div class="card-header"></div>
                                    <div class="card-content">
                                        <div class="team-avatar"></div>
                                        <div class="team-avatar"></div>
                                        <div class="team-avatar"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="bee-mascot" role="img" aria-label="BeeTask mascot">🐝</div>
                        </div>
                    </div>
                    <div class="step-content">
                        <div class="content-wrapper">
                            <h1 id="step-1-title" class="step-title">Welcome to BeeTask</h1>
                            <p class="step-description">Your intelligent project management companion that helps teams work smarter, not harder. Let's take a quick tour of the features that will transform your productivity.</p>
                            <div class="feature-preview">
                                <div class="preview-item">
                                    <div class="preview-icon" role="img" aria-label="Target icon">🎯</div>
                                    <div class="preview-text">
                                        <strong>Smart Project Organization</strong>
                                        <span>Intuitive boards and workflows</span>
                                    </div>
                                </div>
                                <div class="preview-item">
                                    <div class="preview-icon" role="img" aria-label="Robot icon">🤖</div>
                                    <div class="preview-text">
                                        <strong>AI-Powered Insights</strong>
                                        <span>Intelligent task recommendations</span>
                                    </div>
                                </div>
                                <div class="preview-item">
                                    <div class="preview-icon" role="img" aria-label="Chart icon">📊</div>
                                    <div class="preview-text">
                                        <strong>Advanced Analytics</strong>
                                        <span>Data-driven decision making</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Step 2: Create Projects -->
            <section id="step-2" class="tutorial-step" aria-labelledby="step-2-title">
                <div class="step-container">
                    <div class="step-visual">
                        <div class="project-illustration">
                            <div class="project-workspace">
                                <div class="workspace-header">
                                    <div class="project-title">Marketing Campaign</div>
                                    <div class="project-members">
                                        <div class="member-avatar" title="Team Member 1"></div>
                                        <div class="member-avatar" title="Team Member 2"></div>
                                        <div class="member-avatar" title="Team Member 3"></div>
                                        <button class="add-member" aria-label="Add team member">+</button>
                                    </div>
                                </div>
                                <div class="workspace-content">
                                    <div class="project-stats">
                                        <div class="stat-item">
                                            <div class="stat-number">12</div>
                                            <div class="stat-label">Tasks</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">3</div>
                                            <div class="stat-label">Members</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-number">75%</div>
                                            <div class="stat-label">Progress</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="step-content">
                        <div class="content-wrapper">
                            <h2 id="step-2-title" class="step-title">Create Your First Project</h2>
                            <p class="step-description">Projects are the foundation of your workflow. Set up dedicated spaces for different initiatives, complete with team members, goals, and timelines.</p>
                            <div class="step-guide">
                                <div class="guide-item">
                                    <div class="guide-number">1</div>
                                    <div class="guide-content">
                                        <strong>Define Your Project</strong>
                                        <span>Give it a clear name and description that your team will understand</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-number">2</div>
                                    <div class="guide-content">
                                        <strong>Set Goals & Timeline</strong>
                                        <span>Establish clear objectives and realistic deadlines</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-number">3</div>
                                    <div class="guide-content">
                                        <strong>Invite Your Team</strong>
                                        <span>Add collaborators and define their roles and permissions</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Step 3: Tasks & Boards -->
            <section id="step-3" class="tutorial-step" aria-labelledby="step-3-title">
                <div class="step-container">
                    <div class="step-visual">
                        <div class="kanban-illustration">
                            <div class="kanban-board">
                                <div class="kanban-column">
                                    <div class="column-header">To Do</div>
                                    <div class="kanban-card">
                                        <div class="card-title"></div>
                                        <div class="card-meta">
                                            <div class="card-priority high" title="High Priority"></div>
                                            <div class="card-assignee" title="Assigned to team member"></div>
                                        </div>
                                    </div>
                                    <div class="kanban-card">
                                        <div class="card-title"></div>
                                        <div class="card-meta">
                                            <div class="card-priority medium" title="Medium Priority"></div>
                                            <div class="card-assignee" title="Assigned to team member"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="kanban-column">
                                    <div class="column-header">In Progress</div>
                                    <div class="kanban-card">
                                        <div class="card-title"></div>
                                        <div class="card-meta">
                                            <div class="card-priority high" title="High Priority"></div>
                                            <div class="card-assignee" title="Assigned to team member"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="kanban-column">
                                    <div class="column-header">Done</div>
                                    <div class="kanban-card completed">
                                        <div class="card-title"></div>
                                        <div class="card-meta">
                                            <div class="card-priority low" title="Low Priority"></div>
                                            <div class="card-assignee" title="Assigned to team member"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="step-content">
                        <div class="content-wrapper">
                            <h2 id="step-3-title" class="step-title">Organize with Boards & Tasks</h2>
                            <p class="step-description">Transform your ideas into actionable tasks using our intuitive Kanban boards. Visualize progress and keep everyone aligned on priorities.</p>
                            <div class="step-guide">
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Clipboard icon">📋</div>
                                    <div class="guide-content">
                                        <strong>Create Custom Boards</strong>
                                        <span>Design workflows that match your team's process</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Pencil icon">✏️</div>
                                    <div class="guide-content">
                                        <strong>Add Detailed Tasks</strong>
                                        <span>Include descriptions, attachments, and checklists</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Target icon">🎯</div>
                                    <div class="guide-content">
                                        <strong>Drag & Drop Simplicity</strong>
                                        <span>Update status with effortless card movement</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Step 4: Assign & Label -->
            <section id="step-4" class="tutorial-step" aria-labelledby="step-4-title">
                <div class="step-container">
                    <div class="step-visual">
                        <div class="assignment-illustration">
                            <div class="task-detail-card">
                                <div class="task-header">
                                    <div class="task-title">Design Homepage Mockup</div>
                                    <div class="task-labels">
                                        <span class="label design">Design</span>
                                        <span class="label priority">High Priority</span>
                                        <span class="label urgent">Urgent</span>
                                    </div>
                                </div>
                                <div class="task-assignment">
                                    <div class="assignee-section">
                                        <div class="section-title">Assigned to</div>
                                        <div class="assignee-list">
                                            <div class="assignee-avatar sarah" title="Sarah Johnson"></div>
                                            <div class="assignee-avatar john" title="John Smith"></div>
                                        </div>
                                    </div>
                                    <div class="due-date-section">
                                        <div class="section-title">Due Date</div>
                                        <div class="due-date">Dec 15, 2024</div>
                                    </div>
                                </div>
                                <div class="task-progress">
                                    <div class="progress-header">
                                        <span>Progress</span>
                                        <span>60%</span>
                                    </div>
                                    <div class="progress-bar-task">
                                        <div class="progress-fill-task"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="step-content">
                        <div class="content-wrapper">
                            <h2 id="step-4-title" class="step-title">Assign Tasks & Add Labels</h2>
                            <p class="step-description">Ensure accountability and clarity by assigning tasks to specific team members and using colorful labels to categorize and prioritize work.</p>
                            <div class="step-guide">
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="People icon">👥</div>
                                    <div class="guide-content">
                                        <strong>Smart Assignment</strong>
                                        <span>Assign based on skills, workload, and availability</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Label icon">🏷️</div>
                                    <div class="guide-content">
                                        <strong>Color-Coded Labels</strong>
                                        <span>Categorize by priority, department, or project phase</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Clock icon">⏰</div>
                                    <div class="guide-content">
                                        <strong>Smart Deadlines</strong>
                                        <span>Set realistic timelines with automatic reminders</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Step 5: AI & Analytics -->
            <section id="step-5" class="tutorial-step" aria-labelledby="step-5-title">
                <div class="step-container">
                    <div class="step-visual">
                        <div class="ai-analytics-illustration">
                            <div class="ai-panel">
                                <div class="ai-header">
                                    <div class="ai-icon" role="img" aria-label="AI Robot">🤖</div>
                                    <div class="ai-title">AI Assistant</div>
                                </div>
                                <div class="ai-suggestions">
                                    <div class="suggestion-item">
                                        <div class="suggestion-icon" role="img" aria-label="Light bulb">💡</div>
                                        <div class="suggestion-text">Consider moving "Code Review" to high priority</div>
                                    </div>
                                    <div class="suggestion-item">
                                        <div class="suggestion-icon" role="img" aria-label="Chart trending up">📈</div>
                                        <div class="suggestion-text">Team productivity up 23% this week</div>
                                    </div>
                                </div>
                            </div>
                            <div class="analytics-panel">
                                <div class="analytics-header">Analytics Dashboard</div>
                                <div class="analytics-content">
                                    <div class="metric-card">
                                        <div class="metric-value">24</div>
                                        <div class="metric-label">Tasks Completed</div>
                                        <div class="metric-trend up">+12%</div>
                                    </div>
                                    <div class="metric-card">
                                        <div class="metric-value">8.5</div>
                                        <div class="metric-label">Avg. Task Time</div>
                                        <div class="metric-trend down">-15%</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="step-content">
                        <div class="content-wrapper">
                            <h2 id="step-5-title" class="step-title">AI Insights & Analytics</h2>
                            <p class="step-description">Leverage artificial intelligence to optimize your workflow and gain deep insights into team performance with comprehensive analytics and reporting.</p>
                            <div class="step-guide">
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Robot icon">🤖</div>
                                    <div class="guide-content">
                                        <strong>Intelligent Suggestions</strong>
                                        <span>Get AI-powered recommendations for task prioritization</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Bar chart icon">📊</div>
                                    <div class="guide-content">
                                        <strong>Real-time Analytics</strong>
                                        <span>Monitor productivity metrics and team performance</span>
                                    </div>
                                </div>
                                <div class="guide-item">
                                    <div class="guide-icon" role="img" aria-label="Trending up icon">📈</div>
                                    <div class="guide-content">
                                        <strong>Predictive Insights</strong>
                                        <span>Forecast project completion and identify bottlenecks</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Completion Step -->
            <section id="step-complete" class="tutorial-step completion-step" aria-labelledby="completion-title">
                <div class="step-container">
                    <div class="completion-visual">
                        <div class="success-animation">
                            <div class="success-circle">
                                <div class="checkmark">✓</div>
                            </div>
                            <div class="confetti-container" aria-hidden="true">
                                <div class="confetti"></div>
                                <div class="confetti"></div>
                                <div class="confetti"></div>
                                <div class="confetti"></div>
                                <div class="confetti"></div>
                            </div>
                        </div>
                    </div>
                    <div class="step-content">
                        <div class="content-wrapper completion-content">
                            <h2 id="completion-title" class="step-title">You're Ready to Buzz! 🐝</h2>
                            <p class="step-description">Congratulations! You've mastered the basics of BeeTask. You're now equipped with all the tools you need to lead your team to success.</p>
                            <div class="completion-stats">
                                <div class="stat-item">
                                    <div class="stat-icon" role="img" aria-label="Target">🎯</div>
                                    <div class="stat-text">5 Key Features Learned</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-icon" role="img" aria-label="Lightning">⚡</div>
                                    <div class="stat-text">Ready to Boost Productivity</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-icon" role="img" aria-label="Rocket">🚀</div>
                                    <div class="stat-text">Time to Create Your First Project</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <!-- Navigation -->
        <nav class="tutorial-navigation" role="navigation" aria-label="Tutorial navigation">
            <button id="prevBtn" class="nav-button secondary" disabled aria-label="Go to previous step">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                    <path d="M15.41 16.59L10.83 12l4.58-4.59L14 6l-6 6 6 6 1.41-1.41z"/>
                </svg>
                <span>Previous</span>
            </button>
            
            <div class="step-dots" role="tablist" aria-label="Tutorial steps">
                <button class="dot active" data-step="1" role="tab" aria-label="Step 1: Welcome" aria-selected="true"></button>
                <button class="dot" data-step="2" role="tab" aria-label="Step 2: Create Projects" aria-selected="false"></button>
                <button class="dot" data-step="3" role="tab" aria-label="Step 3: Tasks and Boards" aria-selected="false"></button>
                <button class="dot" data-step="4" role="tab" aria-label="Step 4: Assign and Label" aria-selected="false"></button>
                <button class="dot" data-step="5" role="tab" aria-label="Step 5: AI and Analytics" aria-selected="false"></button>
            </div>
            
            <button id="nextBtn" class="nav-button primary" aria-label="Go to next step">
                <span>Next</span>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                    <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
                </svg>
            </button>
            
            <button id="completeBtn" class="nav-button complete" style="display: none;" aria-label="Complete tutorial and start using BeeTask">
                <span>Start Using BeeTask</span>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                    <path d="M9 16.17L5.53 12.7c-.39-.39-1.02-.39-1.41 0-.39.39-.39 1.02 0 1.41l4.18 4.18c.39.39 1.02.39 1.41 0L20.29 6.71c.39-.39.39-1.02 0-1.41-.39-.39-1.02-.39-1.41 0L9 16.17z"/>
                </svg>
            </button>
        </nav>
    </div>

    <!-- Scripts -->
    <script src="tutorial.js"></script>
    <script>
        // Initialize tutorial when DOM is ready
        document.addEventListener('DOMContentLoaded', () => {
            // Hide loading screen
            const loadingScreen = document.getElementById('loadingScreen');
            if (loadingScreen) {
                setTimeout(() => {
                    loadingScreen.style.opacity = '0';
                    setTimeout(() => {
                        loadingScreen.style.display = 'none';
                    }, 300);
                }, 1000);
            }

            // Initialize tutorial if not completed
            const tutorialApp = document.getElementById('tutorialApp');
            if (tutorialApp) {
                tutorialApp.style.display = 'flex';
                tutorialApp.style.opacity = '1';
                document.body.style.overflow = 'hidden';
                
                window.tutorialController = new TutorialController();
                
                // Set completion callback to redirect to home
                window.tutorialController.onComplete(() => {
                    setTimeout(() => {
                        window.location.href = 'Home.jsp';
                    }, 1500);
                });
            } else if (tutorialApp) {
                tutorialApp.style.display = 'none';
            }
        });

        // Handle page visibility changes
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden && window.tutorialController) {
                window.tutorialController.handleVisibilityChange();
            }
        });
    </script>
</body>
</html>
