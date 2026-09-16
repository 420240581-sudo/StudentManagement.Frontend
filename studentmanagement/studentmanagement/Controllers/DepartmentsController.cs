using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using studentmanagement.Data;
using studentmanagement.Models;

namespace studentmanagement.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DepartmentsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public DepartmentsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetDepartments()
        {
            var departments = await _context.Departments.ToListAsync();

            return Ok(departments);
        }

        [HttpPost]
        public async Task<IActionResult> AddDepartment(Department department)
        {
            if (string.IsNullOrWhiteSpace(department.Name))
            {
                return BadRequest("Department name is required.");
            }

            department.Creationdata = DateTime.Now;

            _context.Departments.Add(department);

            await _context.SaveChangesAsync();

            return Ok(department);
        }
    }
}