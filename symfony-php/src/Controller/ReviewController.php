<?php

namespace App\Controller;

use App\Entity\Review;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use App\Repository\ReviewRepository;
use Doctrine\ORM\EntityManagerInterface;

final class ReviewController extends AbstractController
{
    #[Route('/review', name: 'review_show_all', methods: ['GET'])]
    public function show_all(ReviewRepository $reviewRepository): Response
    {
        $reviews = $reviewRepository->findAll();
        return $this->render('review/show_all.html.twig', ['reviews' => $reviews]);
    }

    #[Route('/review/{id}', name: 'review_show', methods: ['GET'])]
    public function show(ReviewRepository $reviewRepository, int $id): Response
    {
        $review = $reviewRepository->find($id);
        if (!$review) { return new Response('No review found for id '.$id, 400); }

        return $this->render('review/show.html.twig', ['review' => $review]);
    }

    #[Route('/review', name: 'review_create', methods: ['POST'])]
    public function create(EntityManagerInterface $entityManager, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $contentType = $request->headers->get('Content-Type');
        if (str_contains($contentType, 'application/json')) $data = json_decode($request->getContent(), true); // JSON
        else $data = $request->request->all(); // Form

        if (!isset($data['productID']) || !isset($data['rating'])) {
            return new Response('Invalid data', 400);
        }
        if ($data['rating'] < 1 || $data['rating'] > 5) {
            return new Response('Invalid rating: should be from 1 to 5', 400);
        }

        $review = new Review();
        $review->setProductID($data['productID']);
        $review->setRating($data['rating']);

        $entityManager->persist($review);
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }

    #[Route('/review/{id}', name: 'review_edit', methods: ['PUT'])]
    public function update(EntityManagerInterface $entityManager, ReviewRepository $reviewRepository, int $id, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $review = $reviewRepository->find($id);
        if (!$review) { return new Response('No review found for id '.$id, 400); }

        $contentType = $request->headers->get('Content-Type');
        if (str_contains($contentType, 'application/json')) $data = json_decode($request->getContent(), true); // JSON
        else $data = $request->request->all(); // Form

        if (isset($data['productID'])) { $review->setProductID($data['productID']); }
        if (isset($data['rating'])) {
            if ($data['rating'] < 1 || $data['rating'] > 5) {
                return new Response('Invalid rating: should be from 1 to 5', 400);
            }
            $review->setRating($data['rating']);
        }
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }

    #[Route('/review/edit/{id}', name: 'review_edit_form', methods: ['GET'])]
    public function edit_form(Request $request, ReviewRepository $reviewRepository, int $id): Response
    {
        if (!$request->getSession()->get('username')) { return $this->redirectToRoute('login'); }

        $review = $reviewRepository->find($id);
        if (!$review) { return new Response('No review found for id '.$id, 400); }

        return $this->render('review/edit.html.twig', ['review' => $review]);
    }

    #[Route('/review/{id}', name: 'review_delete', methods: ['DELETE'])]
    public function delete(EntityManagerInterface $entityManager, ReviewRepository $reviewRepository, int $id, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $review = $reviewRepository->find($id);
        if (!$review) { return new Response('No review found for id '.$id, 400); }

        $entityManager->remove($review);
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }
}
