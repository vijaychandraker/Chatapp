using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace chat2
{
    public class DBHelper
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["ChatAppConnection"].ConnectionString;

        // Execute Non-Query (INSERT, UPDATE, DELETE)
        public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        // Execute Scalar (COUNT, MAX, etc.)
        public static object ExecuteScalar(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }

        // Execute Reader (SELECT)
        public static DataTable ExecuteDataTable(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        // Execute Reader with SqlDataReader
        public static SqlDataReader ExecuteReader(string query, SqlParameter[] parameters = null)
        {
            SqlConnection conn = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand(query, conn);

            if (parameters != null)
            {
                cmd.Parameters.AddRange(parameters);
            }

            conn.Open();
            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }
    }

    // User Data Access Layer
    public class UserDAL
    {
        public static DataTable ValidateUser(string username, string password)
        {
            string query = "SELECT UserId, Username, FullName, UserRole FROM Users WHERE Username = @Username AND Password = @Password AND IsActive = 1";
            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", password)
            };
            return DBHelper.ExecuteDataTable(query, parameters);
        }

        public static int RegisterUser(string username, string email, string password, string fullName)
        {
            string query = @"INSERT INTO Users (Username, Email, Password, FullName, UserRole, IsActive, CreatedDate) 
                            VALUES (@Username, @Email, @Password, @FullName, 'User', 1, GETDATE())";
            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Email", email),
                new SqlParameter("@Password", password),
                new SqlParameter("@FullName", fullName)
            };
            return DBHelper.ExecuteNonQuery(query, parameters);
        }

        public static bool CheckUsernameExists(string username)
        {
            string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
            SqlParameter[] parameters = {
                new SqlParameter("@Username", username)
            };
            int count = Convert.ToInt32(DBHelper.ExecuteScalar(query, parameters));
            return count > 0;
        }

        public static void UpdateLastLogin(int userId)
        {
            string query = "UPDATE Users SET LastLoginDate = GETDATE() WHERE UserId = @UserId";
            SqlParameter[] parameters = {
                new SqlParameter("@UserId", userId)
            };
            DBHelper.ExecuteNonQuery(query, parameters);
        }

        public static DataTable GetAllUsers()
        {
            string query = "SELECT UserId, Username, Email, FullName, UserRole, CreatedDate, LastLoginDate FROM Users WHERE UserRole = 'User' ORDER BY CreatedDate DESC";
            return DBHelper.ExecuteDataTable(query);
        }
    }

    // ChatRoom Data Access Layer
    public class ChatRoomDAL
    {
        public static DataTable GetUserChatRooms(int userId)
        {
            string query = @"SELECT cr.ChatRoomId, cr.RoomName, cr.CreatedDate, 
                            u.FullName as UserName, a.FullName as AdminName
                            FROM ChatRooms cr
                            INNER JOIN Users u ON cr.UserId = u.UserId
                            INNER JOIN Users a ON cr.AdminId = a.UserId
                            WHERE cr.UserId = @UserId AND cr.IsActive = 1
                            ORDER BY cr.CreatedDate DESC";
            SqlParameter[] parameters = {
                new SqlParameter("@UserId", userId)
            };
            return DBHelper.ExecuteDataTable(query, parameters);
        }

        public static DataTable GetAdminChatRooms()
        {
            string query = @"SELECT cr.ChatRoomId, cr.RoomName, cr.CreatedDate, 
                            u.FullName as UserName, a.FullName as AdminName,
                            (SELECT COUNT(*) FROM Messages WHERE ChatRoomId = cr.ChatRoomId AND IsRead = 0) as UnreadCount
                            FROM ChatRooms cr
                            INNER JOIN Users u ON cr.UserId = u.UserId
                            INNER JOIN Users a ON cr.AdminId = a.UserId
                            WHERE cr.IsActive = 1
                            ORDER BY cr.CreatedDate DESC";
            return DBHelper.ExecuteDataTable(query);
        }

        public static int CreateChatRoom(string roomName, int userId, int adminId)
        {
            string query = @"INSERT INTO ChatRooms (RoomName, UserId, AdminId, CreatedDate, IsActive) 
                            VALUES (@RoomName, @UserId, @AdminId, GETDATE(), 1);
                            SELECT SCOPE_IDENTITY();";
            SqlParameter[] parameters = {
                new SqlParameter("@RoomName", roomName),
                new SqlParameter("@UserId", userId),
                new SqlParameter("@AdminId", adminId)
            };
            return Convert.ToInt32(DBHelper.ExecuteScalar(query, parameters));
        }

        public static DataTable GetChatRoomDetails(int chatRoomId)
        {
            string query = @"SELECT cr.ChatRoomId, cr.RoomName, cr.UserId, cr.AdminId,
                            u.FullName as UserName, a.FullName as AdminName
                            FROM ChatRooms cr
                            INNER JOIN Users u ON cr.UserId = u.UserId
                            INNER JOIN Users a ON cr.AdminId = a.UserId
                            WHERE cr.ChatRoomId = @ChatRoomId";
            SqlParameter[] parameters = {
                new SqlParameter("@ChatRoomId", chatRoomId)
            };
            return DBHelper.ExecuteDataTable(query, parameters);
        }
    }

    // Message Data Access Layer
    public class MessageDAL
    {
        public static DataTable GetMessages(int chatRoomId)
        {
            string query = @"SELECT m.MessageId, m.SenderId, m.MessageText, m.SentDate, m.IsRead,
                            u.FullName as SenderName
                            FROM Messages m
                            INNER JOIN Users u ON m.SenderId = u.UserId
                            WHERE m.ChatRoomId = @ChatRoomId
                            ORDER BY m.SentDate ASC";
            SqlParameter[] parameters = {
                new SqlParameter("@ChatRoomId", chatRoomId)
            };
            return DBHelper.ExecuteDataTable(query, parameters);
        }

        public static int SendMessage(int chatRoomId, int senderId, string messageText)
        {
            string query = @"INSERT INTO Messages (ChatRoomId, SenderId, MessageText, SentDate, IsRead) 
                            VALUES (@ChatRoomId, @SenderId, @MessageText, GETDATE(), 0)";
            SqlParameter[] parameters = {
                new SqlParameter("@ChatRoomId", chatRoomId),
                new SqlParameter("@SenderId", senderId),
                new SqlParameter("@MessageText", messageText)
            };
            return DBHelper.ExecuteNonQuery(query, parameters);
        }

        public static void MarkMessagesAsRead(int chatRoomId, int userId)
        {
            string query = "UPDATE Messages SET IsRead = 1 WHERE ChatRoomId = @ChatRoomId AND SenderId != @UserId";
            SqlParameter[] parameters = {
                new SqlParameter("@ChatRoomId", chatRoomId),
                new SqlParameter("@UserId", userId)
            };
            DBHelper.ExecuteNonQuery(query, parameters);
        }
    }

    // Document Data Access Layer
    public class DocumentDAL
    {
        public static DataTable GetDocuments(int chatRoomId)
        {
            string query = @"SELECT d.DocumentId, d.FileName, d.FilePath, d.FileSize, d.FileType, d.UploadDate,
                            u.FullName as UploaderName
                            FROM Documents d
                            INNER JOIN Users u ON d.UploadedBy = u.UserId
                            WHERE d.ChatRoomId = @ChatRoomId
                            ORDER BY d.UploadDate DESC";
            SqlParameter[] parameters = {
                new SqlParameter("@ChatRoomId", chatRoomId)
            };
            return DBHelper.ExecuteDataTable(query, parameters);
        }

        public static int UploadDocument(int chatRoomId, int uploadedBy, string fileName, string filePath, long fileSize, string fileType)
        {
            string query = @"INSERT INTO Documents (ChatRoomId, UploadedBy, FileName, FilePath, FileSize, FileType, UploadDate) 
                            VALUES (@ChatRoomId, @UploadedBy, @FileName, @FilePath, @FileSize, @FileType, GETDATE())";
            SqlParameter[] parameters = {
                new SqlParameter("@ChatRoomId", chatRoomId),
                new SqlParameter("@UploadedBy", uploadedBy),
                new SqlParameter("@FileName", fileName),
                new SqlParameter("@FilePath", filePath),
                new SqlParameter("@FileSize", fileSize),
                new SqlParameter("@FileType", fileType)
            };
            return DBHelper.ExecuteNonQuery(query, parameters);
        }

        public static DataTable GetDocumentById(int documentId)
        {
            string query = "SELECT DocumentId, FileName, FilePath FROM Documents WHERE DocumentId = @DocumentId";
            SqlParameter[] parameters = {
                new SqlParameter("@DocumentId", documentId)
            };
            return DBHelper.ExecuteDataTable(query, parameters);
        }
    }
}