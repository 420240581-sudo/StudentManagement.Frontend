using Microsoft.EntityFrameworkCore;
using studentmanagement.Models;

namespace studentmanagement.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<Student> Students { get; set; }

        public DbSet<Department> Departments { get; set; }
    }
}
