using System.ComponentModel.DataAnnotations.Schema;

namespace studentmanagement.Models
{
    [Table("department")]
    public class Department
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public DateTime Creationdata { get; set; }
    }
}
