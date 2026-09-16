using System.ComponentModel.DataAnnotations.Schema;

namespace studentmanagement.Models
{
    [Table("student")]
    public class Student
    {
        public int Id { get; set; }

        public string Name { get; set; }

        [Column("department_id")]
        public int DepartmentId { get; set; }

        public int Age { get; set; }

        public string Email { get; set; }

        public DateTime Creationdata { get; set; }
    }
}