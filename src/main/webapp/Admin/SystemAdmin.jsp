<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.ProjectOverview, model.User" %>

<%@ page import="java.util.*" %>
<%@ page import="java.util.stream.*" %>
<%@ page import="java.util.stream.Collectors" %>

<%@ include file="../session-check.jspf" %>
<%@ page import="java.util.*, java.util.stream.*, java.util.stream.Collectors" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="HeaderAdmin.jsp" %>
        <title>All Projects - Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/SystemAdmin.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>


    </head>
    <body class="dashboard-body">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="user-profile">
                    <div class="avatar">
                        <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
                        <% } else { %>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #ccc;"></div>
                        <% } %>
                    </div>
                    <div class="info">
                        <span class="username"><%= user.getUsername() %></span>
                        <span class="email"><%= user.getEmail() %></span>
                    </div>
                </div>

                <%@ include file="SidebarAdmin.jsp" %>
                <%@ include file="../Help.jsp" %>
            </aside>

            <!-- Main -->
            <main class="main-content">
                <h1>Dashboard</h1>

                
                    <%
    Map<String, Integer> summary = (Map<String, Integer>) request.getAttribute("userSummaryStats");
%>

<div class="user-summary-cards" style="display: flex; gap: 20px; margin-top: 20px;">
    <div class="card" style="flex: 1; background-color: #f3f4f6; border-radius: 10px; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        <h3 style="margin-bottom: 10px;">👥 Total Users</h3>
        <p style="font-size: 24px; font-weight: bold;"><%= summary.get("TotalUsers") %></p>
    </div>
    <div class="card" style="flex: 1; background-color: #fde68a; border-radius: 10px; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        <h3 style="margin-bottom: 10px;">🔒 Blocked Users</h3>
        <p style="font-size: 24px; font-weight: bold;"><%= summary.get("BlockedUsers") %></p>
    </div>
    <div class="card" style="flex: 1; background-color: #bbf7d0; border-radius: 10px; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        <h3 style="margin-bottom: 10px;">🌟 Premium Users</h3>
        <p style="font-size: 24px; font-weight: bold;"><%= summary.get("PremiumUsers") %></p>
    </div>
</div>

                    
                    
                

                
                
                
                
                
                
                <div class="charts-row">




                    <div class="chart-section">
                        <h2>Number of new users by week</h2>
                        <canvas id="barChart"></canvas>
                    </div>



                    <div class="chart-section">
                        <canvas id="userStatusPieChart"></canvas>

                    </div>


                </div>

    
    
    

<%
    Map<String, Integer> projectSummary = (Map<String, Integer>) request.getAttribute("projectSummaryStats");
    int totalProjects = projectSummary.get("TotalProjects");
    int lockedProjects = projectSummary.get("LockedProjects");
    int unlockedProjects = totalProjects - lockedProjects;
%>

<div class="project-summary-cards" style="display: flex; gap: 20px; margin-top: 20px;">
    <div class="card" style="flex: 1; background-color: #e0f2fe; border-radius: 10px; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        <h3 style="margin-bottom: 10px;">📊 Total Projects</h3>
        <p style="font-size: 24px; font-weight: bold;"><%= totalProjects %></p>
    </div>
    <div class="card" style="flex: 1; background-color: #fecaca; border-radius: 10px; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        <h3 style="margin-bottom: 10px;">🔒 Locked Projects</h3>
        <p style="font-size: 24px; font-weight: bold;"><%= lockedProjects %></p>
    </div>
    <div class="card" style="flex: 1; background-color: #dcfce7; border-radius: 10px; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        <h3 style="margin-bottom: 10px;">🔓 Unlocked Projects</h3>
        <p style="font-size: 24px; font-weight: bold;"><%= unlockedProjects %></p>
    </div>
</div>


                <div class="charts-row">


                    <div class="chart-section">
                        <h2>Project number charts are created by week</h2>
                        <canvas id="projectLineChart"></canvas>
                    </div>
                    
                    
                    
                    
                    
                    <!-- 2. Canvas hiển thị biểu đồ -->
                    <div class="chart-section">
                        <canvas id="projectLockPieChart" width="300" height="300"></canvas>

                    </div>

                    
                    
                    

                </div>




            </main>
        </div>









        <%
        List<Map<String, Object>> stats = (List<Map<String, Object>>) request.getAttribute("stats");

        Map<String, Map<String, Integer>> dataMap = new LinkedHashMap<>();
        for (Map<String, Object> entry : stats) {
            String week = (String) entry.get("week");
            String role = (String) entry.get("role");
            int count = (Integer) entry.get("count");

            dataMap.putIfAbsent(week, new HashMap<>());
            dataMap.get(week).put(role, count);
        }

        List<String> weeks = new ArrayList<>(dataMap.keySet());
        Collections.reverse(weeks);

        List<Integer> userCounts = weeks.stream()
                .map(week -> dataMap.get(week).getOrDefault("User", 0))
                .collect(Collectors.toList());

        List<Integer> premiumCounts = weeks.stream()
                .map(week -> dataMap.get(week).getOrDefault("Premium", 0))
                .collect(Collectors.toList());

        String weekLabels = weeks.stream()
                .map(w -> "\"" + w + "\"")
                .collect(Collectors.joining(", ", "[", "]"));
        %>














        <%
    Map<String, Integer> pieDataMap = (Map<String, Integer>) request.getAttribute("userStatusPieData");
    StringBuilder pieLabels = new StringBuilder("[");
    StringBuilder pieValues = new StringBuilder("[");

    if (pieDataMap != null) {
        for (Map.Entry<String, Integer> entry : pieDataMap.entrySet()) {
            pieLabels.append("\"").append(entry.getKey()).append("\",");
            pieValues.append(entry.getValue()).append(",");
        }

        // Xóa dấu phẩy cuối cùng
        if (pieLabels.length() > 1) pieLabels.setLength(pieLabels.length() - 1);
        if (pieValues.length() > 1) pieValues.setLength(pieValues.length() - 1);
    }

    pieLabels.append("]");
    pieValues.append("]");
        %>





        <script>
            const barCtx = document.getElementById('barChart').getContext('2d');
            const chart = new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: <%= weekLabels %>,
                    datasets: [
                        {
                            label: 'User',
                            data: <%= userCounts.toString() %>,
                            backgroundColor: '#4caf50'
                        },
                        {
                            label: 'Premium',
                            data: <%= premiumCounts.toString() %>,
                            backgroundColor: '#2196f3'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: {
                        title: {
                            display: true,
                            text: ''
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {display: true, text: 'Quantity'}
                        },
                        x: {
                            title: {display: true, text: 'Week start'}
                        }
                    }
                }
            });












            const projectLabels = [];
            const projectCounts = [];

            <% 
        List<Map<String, Object>> projectStats = (List<Map<String, Object>>) request.getAttribute("projectStats");
        int weekNum = 1;
        for (Map<String, Object> row : projectStats) {
            java.sql.Date weekStart = (java.sql.Date) row.get("week");
            int count = (int) row.get("count");

            java.time.LocalDate date = weekStart.toLocalDate();
            int month = date.getMonthValue();

           out.println("projectLabels.push('Week " + weekNum + " (M" + month + ")');");

            out.println("projectCounts.push(" + count + ");");
            weekNum++;
        }
            %>
                
                
                
                
                
                
                const isDarkMode = document.body.classList.contains("dark-mode"); // hoặc class bạn dùng cho dark mode

const axisColor = isDarkMode ? 'white' : 'black';
const legendTextColor = isDarkMode ? 'white' : 'black';


            new Chart(document.getElementById('projectLineChart'), {
                type: 'line',
                data: {
                    labels: projectLabels,
                    datasets: [{
                            label: 'Number of new created projects',
                            data: projectCounts,
                            fill: false,
                            borderColor: '#f97316',
                            backgroundColor: '#f97316',
                            tension: 0.3
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            labels: {
                                color: legendTextColor
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                color: axisColor  
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                color: axisColor  
                            }
                        }
                    }
                }
            });














            const pieData = {
                labels: <%= pieLabels.toString() %>,
                datasets: [{
                        data: <%= pieValues.toString() %>,
                        backgroundColor: ['#4caf50', '#f44336', '#2196f3', '#ff9800', '#9c27b0'], // màu cho từng phần
                        borderWidth: 1
                    }]
            };




            const pieConfig = {
                type: 'pie',
                data: pieData,
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
//                                color: '#000' // Nếu nền tối
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    let value = context.raw;
                                    let percentage = ((value / total) * 100).toFixed(1);
                                    return `${context.label}: ${value} (${percentage}%)`;
                                }
                            }
                        },
                        datalabels: {
                            color: '#fff',
                            formatter: function (value, context) {
                                let total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                                let percentage = ((value / total) * 100).toFixed(1);
                                return percentage + '%';
                            },
                            font: {
                                weight: 'bold',
                                size: 14
                            }
                        }
                    }
                },
                plugins: [ChartDataLabels]
            };


            const pieCtx = document.getElementById("userStatusPieChart").getContext("2d");
            new Chart(pieCtx, pieConfig);







//sử lí biểu đồ tròn project 
 // 3. Lấy dữ liệu từ JSP
    const projectLockStatusData = {
        <% 
            Map<String, Integer> map = (Map<String, Integer>) request.getAttribute("projectLockStatusData");
            int total = map.values().stream().mapToInt(Integer::intValue).sum();
            for (Iterator<Map.Entry<String, Integer>> it = map.entrySet().iterator(); it.hasNext();) {
                Map.Entry<String, Integer> entry = it.next();
                int percentage = Math.round((entry.getValue() * 100.0f) / total);
        %>
        "<%= entry.getKey() %> (<%= percentage %>%)": <%= entry.getValue() %><%= it.hasNext() ? "," : "" %>
        <% } %>
    };

    const pieProjectCtx  = document.getElementById("projectLockPieChart").getContext("2d");
    new Chart(pieProjectCtx , {
        type: 'pie',
        data: {
            labels: Object.keys(projectLockStatusData),
            datasets: [{
                label: 'Project status',
                data: Object.values(projectLockStatusData),
                backgroundColor: ['#ef4444', '#10b981']
            }]
        },
        options: {
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });

        </script>




    </body>
</html>








