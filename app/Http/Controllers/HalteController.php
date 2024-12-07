<?php

namespace App\Http\Controllers;

use App\Models\Halte;
use Illuminate\Http\Request;

class HalteController extends Controller
{
    public function index()
    {
        // Retrieve all haltes from the database
        $haltes = Halte::all();

        // Return the haltes as a JSON response
        return response()->json($haltes);
    }
}
