using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication_API.Models
{
    public class ModeloBase
    {
        [NotMapped]
        public bool TieneError { get; set; }
        [NotMapped]
        public string Error { get; set; }
    }
}
