<?php

namespace App\Controller;

use App\Repository\CategoryRepository;
use App\Repository\ProductRepository;
use App\Repository\ReviewRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class HomeController extends AbstractController
{
    #[Route('/', name: 'home')]
    public function index(): Response
    {
        return $this->render('index.html.twig');
    }

    #[Route('/panel', name: 'panel')]
    public function panel(Request $request, ProductRepository $pr, CategoryRepository $cr, ReviewRepository $rr): Response
    {
        if (!$request->getSession()->get('username')) { return $this->redirectToRoute('login'); }

        $p = $pr->findAll();
        $c = $cr->findAll();
        $r = $rr->findAll();

        return $this->render('panel.html.twig', ['products' => $p, 'categories' => $c, 'reviews' => $r]);
    }
}
