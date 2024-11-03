<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Books Issued by Student</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        .book-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .book-grid th, .book-grid td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .book-grid th {
            background-color: #333;
            color: white;
        }
        .book-grid tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .book-grid tr:hover {
            background-color: #e0e0e0;
        }
        .no-books-message {
            text-align: center;
            color: #555;
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <h1>Books Issued by You</h1>

    <%
        String studentEmail = "hey@hey.com";

        if (studentEmail != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "1234");

                String query = "SELECT book_id, book_name, issue_date FROM issued_books WHERE student_email = ?";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, studentEmail);
                rs = stmt.executeQuery();

                out.println("<table class='book-grid'>");
                out.println("<tr><th>Book ID</th><th>Book Name</th><th>Issue Date</th></tr>");

                boolean hasIssuedBooks = false;
                while (rs.next()) {
                    hasIssuedBooks = true;
                    int bookId = rs.getInt("book_id");
                    String bookName = rs.getString("book_name");
                    String issueDate = rs.getString("issue_date");

                    out.println("<tr>");
                    out.println("<td>" + bookId + "</td>");
                    out.println("<td>" + bookName + "</td>");
                    out.println("<td>" + issueDate + "</td>");
                    out.println("</tr>");
                }

                out.println("</table>");

                if (!hasIssuedBooks) {
                    out.println("<p class='no-books-message'>No books have been issued by you.</p>");
                }

            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            out.println("<p>Please log in to view your issued books.</p>");
        }
    %>
</body>
</html>