<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class LoginController extends AbstractController
{
    #[Route('/login', name: 'login', methods: ['GET'])]
    public function login(): Response
    {
        return $this->render('login.html.twig');
    }

    #[Route('/login', name: 'login_auth', methods: ['POST'])]
    public function login_auth(Request $request): Response
    {
        $username = $request->request->get('username');
        $password = $request->request->get('password');

        if (!$username || !$password) {
            return new Response('Missing data', 400);
        }

        if ($username == 'admin' && $password == 'admin') {
            $request->getSession()->set('username', $username);
            return $this->redirectToRoute('panel');
        }

        return new Response('Invalid login', 400);
    }

    #[Route('/logout', name: 'logout', methods: ['POST'])]
    public function logout(Request $request): Response
    {
        $request->getSession()->remove('username');
        return $this->redirectToRoute('home');
    }
}
