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
<div class="user-summary-cards">
    <div class="card total-users">
        <h3>👥 Total Users</h3>
        <p><%= summary.get("TotalUsers") %></p>
    </div>
    <div class="card blocked-users">
        <h3>🔒 Blocked Users</h3>
        <p><%= summary.get("BlockedUsers") %></p>
    </div>
    <div class="card premium-users">
        <h3>🌟 Premium Users</h3>
        <p><%= summary.get("PremiumUsers") %></p>
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



<div class="project-summary-cards">
    <div class="card total-projects">
        <h3>📊 Total Projects</h3>
        <p><%= totalProjects %></p>
    </div>
    <div class="card locked-projects">
        <h3>🔒 Locked Projects</h3>
        <p><%= lockedProjects %></p>
    </div>
    <div class="card unlocked-projects">
        <h3>🔓 Unlocked Projects</h3>
        <p><%= unlockedProjects %></p>
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
    
    // ✅ THAY ĐỔI: Giới hạn tối đa 8 tuần và tạo labels W1, W2, W3...
    int maxWeeks = Math.min(weeks.size(), 8);
    List<String> limitedWeeks = weeks.subList(0, maxWeeks);
    
    List<Integer> userCounts = limitedWeeks.stream()
            .map(week -> dataMap.get(week).getOrDefault("User", 0))
            .collect(Collectors.toList());
    List<Integer> premiumCounts = limitedWeeks.stream()
            .map(week -> dataMap.get(week).getOrDefault("Premium", 0))
            .collect(Collectors.toList());
    
    // ✅ THAY ĐỔI: Tạo weekLabels với định dạng W1, W2, W3...
    StringBuilder weekLabelsBuilder = new StringBuilder("[");
    for (int i = 0; i < maxWeeks; i++) {
        weekLabelsBuilder.append("\"W").append(i + 1).append("\"");
        if (i < maxWeeks - 1) {
            weekLabelsBuilder.append(", ");
        }
    }
    weekLabelsBuilder.append("]");
    String weekLabels = weekLabelsBuilder.toString();
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
           // Biểu đồ cột với W1, W2, W3... (tối đa 8 tuần)
const chart = new Chart(barCtx, {
    type: 'bar',
    data: {
        labels: <%= weekLabels %>,
        datasets: [
            {
                label: 'User',
                data: <%= userCounts.toString() %>,
                backgroundColor: '#4caf50'
                // ❌ Không dùng barThickness ở đây
            },
            {
                label: 'Premium',
                data: <%= premiumCounts.toString() %>,
                backgroundColor: '#2196f3'
                // ❌ Không dùng barThickness ở đây
            }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            title: {
                display: false
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                title: {display: true, text: 'Quantity'}
            },
            x: {
                title: {display: true, text: 'Week'},
                // ✅ ĐIỀU CHỈNH TỶ LỆ Ở ĐÂY
                categoryPercentage: 0.5,  // 50% không gian cho category
                barPercentage: 0.7        // 70% không gian cho bar
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
                
                
                
                
                
              
//biểu đồ đường 
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
                                
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                               
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                               
                            }
                        }
                    }
                }
            });












// biểu đò tròn người dùng 

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








