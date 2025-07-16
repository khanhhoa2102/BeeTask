package controller;

import dao.BoardDAO;
import model.Board;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/board")
public class BoardController extends HttpServlet {

    private BoardDAO boardDAO;

    @Override
    public void init() {
        boardDAO = new BoardDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "add":
                    addBoard(req, resp);
                    break;
                case "edit":
                    editBoard(req, resp);
                    break;
                case "delete":
                    deleteBoard(req, resp);
                    break;
                case "moveBoardPosition":
                    moveBoardPosition(req, resp);
                    break;
                case "duplicate":
                    duplicateBoard(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request: " + e.getMessage());
        }
    }

    private void addBoard(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    int projectId = Integer.parseInt(req.getParameter("projectId"));
    String name = req.getParameter("name");
    int position = Integer.parseInt(req.getParameter("position"));

    Board board = new Board();
    board.setProjectId(projectId);
    board.setName(name);
    board.setDescription("");
    board.setPosition(position);

    // Insert và lấy lại ID mới
    int newId = boardDAO.insertAndReturnId(board); 

    // Trả JSON cho client
    resp.setContentType("application/json");
    resp.setCharacterEncoding("UTF-8");
    resp.getWriter().write(
        "{ \"success\": true, " +
        "\"boardId\": " + newId + "," +
        "\"name\": \"" + name + "\"," +
        "\"position\": " + position +
        " }"
    );
}


    private void editBoard(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Fix: Use boardId instead of listId for consistency
        int boardId = Integer.parseInt(req.getParameter("boardId"));
        String name = req.getParameter("name");

        Board board = boardDAO.findById(boardId);
        if (board != null) {
            board.setName(name);
            boardDAO.update(board);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Board not found");
        }
    }

    private void deleteBoard(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int boardId = Integer.parseInt(req.getParameter("listId"));

            boardDAO.delete(boardId);
            resp.setStatus(HttpServletResponse.SC_OK); // Trả về thành công cho AJAX
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": true}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void moveBoardPosition(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String[] boardIds = req.getParameterValues("boardIds[]");
        String[] positions = req.getParameterValues("positions[]");

        if (boardIds != null && positions != null) {
            for (int i = 0; i < boardIds.length; i++) {
                int boardId = Integer.parseInt(boardIds[i]);
                int pos = Integer.parseInt(positions[i]);
                boardDAO.updateBoardPosition(boardId, pos);
            }
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing board IDs or positions");
        }
    }

    private void duplicateBoard(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int boardId = Integer.parseInt(req.getParameter("boardId"));

        Board board = boardDAO.findById(boardId);
        if (board != null) {
            boardDAO.duplicate(boardId);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Board not found");
        }
    }
}
