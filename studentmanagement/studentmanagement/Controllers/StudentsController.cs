using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using studentmanagement.Data;
using studentmanagement.Models;

namespace studentmanagement.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StudentsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public StudentsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetStudents()
        {
            var students = await _context.Students
                .Join(
                    _context.Departments,
                    student => student.DepartmentId,
                    department => department.Id,
                    (student, department) => new
                    {
                        student.Id,
                        student.Name,
                        student.Age,
                        Department = department.Name
                    })
                .ToListAsync();

            return Ok(students);
        }

        [HttpGet("search")]
        public async Task<IActionResult> SearchStudents(string text)
        {
            var students = await _context.Students
                .Join(
                    _context.Departments,
                    student => student.DepartmentId,
                    department => department.Id,
                    (student, department) => new
                    {
                        student.Id,
                        student.Name,
                        student.Age,
                        Department = department.Name
                    })
                .Where(s => s.Name.Contains(text))
                .ToListAsync();

            return Ok(students);
        }
    }
}

