using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApplication_API.Data;
using WebApplication_API.Models;

namespace WebApplication_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ColorsController : ControllerBase
    {
        private readonly WebApplication_APIContext _context;

        public ColorsController(WebApplication_APIContext context)
        {
            _context = context;
        }

        // GET: api/Colors
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Color>>> GetColor()
        {
            return await _context.Color.ToListAsync();
        }

        // GET: api/Colors/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Color>> GetColor(decimal id)
        {
            var color = await _context.Color.FindAsync(id);

            if (color == null)
            {
                return NotFound();
            }

            return color;
        }

        [HttpGet("GetByCodigo/{codigo}")]
        //[Route("GetByCodigo")]
        public async Task<ActionResult<Color>> GetByCodigo(string codigo)
        {
            var color = await _context.Color.Where(r=>r.Codigo == codigo).ToListAsync();

            if (color == null)
            {
                return NotFound();
            }

            return color.First();
        }        

        // PUT: api/Colors/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutColor(decimal id, Color color)
        {
            if (id != color.Iden)
            {
                return BadRequest();
            }

            _context.Entry(color).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ColorExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Colors
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Color>> PostColor(Color color)
        {
            _context.Color.Add(color);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetColor", new { id = color.Iden }, color);
        }

        // DELETE: api/Colors/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Color>> DeleteColor(decimal id)
        {
            var color = await _context.Color.FindAsync(id);
            if (color == null)
            {
                return NotFound();
            }

            _context.Color.Remove(color);
            await _context.SaveChangesAsync();

            return color;
        }

        private bool ColorExists(decimal id)
        {
            return _context.Color.Any(e => e.Iden == id);
        }
    }
}
