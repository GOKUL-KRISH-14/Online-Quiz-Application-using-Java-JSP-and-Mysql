<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Results</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .message {
            font-size: 18px;
            color: #333;
        }
        .error {
            color: red;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <% 
            String rollno = request.getParameter("rollno");
            if (rollno == null || rollno.isEmpty()) {
                out.println("<div class='error'>Roll number is required!</div>");
                return;
            }

            // Array of correct answers
            String[] correctAnswers = {"B", "C", "A", "A", "C", "A", "B", "A", "C", "A"};
            int score = 0;

            // Calculate score based on user input
            for (int i = 0; i < correctAnswers.length; i++) {
                String answer = request.getParameter("q" + (i + 1));
                if (answer != null && correctAnswers[i].equals(answer)) {
                    score++;
                }
            }

            // Database connection setup
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                String url = "jdbc:mysql://localhost:3306/_Gokul"; // Ensure your database name and credentials are correct
                String dbUser = "root";
                String dbPassword = "gokul@14"; 
                conn = DriverManager.getConnection(url, dbUser, dbPassword);

                // Check if the roll number already exists
                String checkSql = "SELECT * FROM MarkValues WHERE rollno = ?"; // Ensure correct table name 'mark'
                pst = conn.prepareStatement(checkSql);
                pst.setString(1, rollno);
                rs = pst.executeQuery();
                
                if (rs.next()) {
                    out.println("<div class='error'>Roll number " + rollno + " is already registered.</div>");
                } else {
                    // Insert score into the database
                    String insertSql = "INSERT INTO MarkValues (rollno, mark) VALUES (?, ?)"; // Ensure the case of the table name matches
                    conn.prepareStatement(insertSql);
                    pst.setString(1, rollno);
                    pst.setInt(2, score);
                    int rows = pst.executeUpdate();

                    if (rows > 0) {
                        out.println("<div class='message'>Thank you for taking the quiz! Your score is: " + score + " out of 10.</div>");
                    } else {
                        out.println("<div class='error'>Failed to submit your score. Please try again later.</div>");
                    }
                }
            } catch (SQLException e) {
                out.println("<div class='error'>There was an error processing your request. Please try again later.</div>");
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pst != null) pst.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>
